#!/usr/bin/env python3
import re

def evaluate_expression(expr):
    """Evaluate simple arithmetic expressions like 80*256"""
    try:
        # Only allow numbers, *, +, -, /, parentheses
        if re.match(r'^[\d\s\+\-\*/\(\)]+$', expr):
            return eval(expr)
    except:
        pass
    return None

def convert_size_expression(size_expr):
    """Convert expression to size constant name"""
    # Handle specific expressions
    if 'mt_END-MT_Init' in size_expr:
        return 'PTReplaySize'

    # Handle EndXxx-Xxx pattern
    match = re.match(r'End(\w+)-(\w+)', size_expr)
    if match:
        return match.group(1) + 'Size'

    return size_expr

def count_dc_b_size(values_str):
    """Count size of dc.b directive (handles strings and comma-separated values)"""
    # Check if it's a string constant
    if '"' in values_str:
        # Extract string content
        match = re.search(r'"([^"]*)"', values_str)
        if match:
            return len(match.group(1))

    # Otherwise count comma-separated values
    if ',' in values_str:
        return values_str.count(',') + 1

    # Single value
    return 1

def format_line_with_comment(line, comment, comment_column=47):
    """Format a line with comment aligned to specified column"""
    if not comment:
        return line

    # Calculate spaces needed to reach comment column
    current_len = len(line)
    if current_len >= comment_column:
        # Line is too long, just add a space
        return f"{line} {comment}"
    else:
        spaces_needed = comment_column - current_len
        return f"{line}{' ' * spaces_needed}{comment}"

def parse_9_vars():
    """Parse 9_vars.s and generate globals.i structure"""

    with open('9_vars.s', 'r') as f:
        lines = f.readlines()

    output = []
    output.append(";")
    output.append("; Global Variables Structure ")
    output.append("; Auto-generated from 9_vars.s")
    output.append(";")
    output.append('    include "exec/types.i"')
    output.append("")
    output.append("    STRUCTURE    Globals,0")
    output.append("")

    i = 0
    in_vars_section = False
    anon_count = 0

    while i < len(lines):
        line = lines[i].rstrip()
        original_line = line

        # Extract comment if present
        comment = ''
        comment_line = line
        if ';' in line:
            comment = line[line.index(';'):]  # Keep the ; and comment
            line = line[:line.index(';')]
        line = line.strip()

        # Skip empty lines
        if not line:
            i += 1
            continue

        # Check for start of variables section
        if line.startswith('s_Variables:'):
            in_vars_section = True

        if not in_vars_section:
            i += 1
            continue

        # Handle conditionals (ifeq, ifne, endc, else)
        first_word = line.split()[0] if line.split() else ''
        if first_word in ['ifeq', 'ifne', 'endc', 'else']:
            output.append(f"    {original_line.strip()}")
            i += 1
            continue

        # Check for unlabeled data declarations (no label, just directive)
        if line and not ':' in line:
            parts = comment_line.split()  # Use comment_line to preserve string constants
            if parts and parts[0].lower() in ['dc.l', 'dc.w', 'dc.b', 'dcb.b', 'dcb.l', 'blk.b', 'blk.l', 'ds.b']:
                directive = parts[0].lower()

                # Generate anonymous label
                label = f"_pad{anon_count}"
                anon_count += 1

                if directive == 'dc.l':
                    # Count comma-separated values
                    values_str = comment_line[comment_line.index('dc.l')+4:].strip()
                    if ';' in values_str:
                        values_str = values_str[:values_str.index(';')].strip()
                    if ',' in values_str:
                        count = values_str.count(',') + 1
                        output.append(f"        STRUCT    {label},{count}*4")
                    else:
                        output.append(f"        LONG      {label}")
                elif directive == 'dc.w':
                    # Count comma-separated values
                    values_str = comment_line[comment_line.index('dc.w')+4:].strip()
                    if ';' in values_str:
                        values_str = values_str[:values_str.index(';')].strip()
                    if ',' in values_str:
                        count = values_str.count(',') + 1
                        output.append(f"        STRUCT    {label},{count}*2")
                    else:
                        output.append(f"        WORD      {label}")
                elif directive == 'dc.b':
                    # Handle strings and comma-separated values
                    values_str = comment_line[comment_line.index('dc.b')+4:].strip()
                    if ';' in values_str:
                        values_str = values_str[:values_str.index(';')].strip()

                    count = count_dc_b_size(values_str)
                    if count == 1:
                        output.append(f"        BYTE      {label}")
                    else:
                        output.append(f"        STRUCT    {label},{count}")
                elif directive == 'dcb.b' or directive == 'blk.b':
                    # Extract size - keep original expression
                    size_expr = parts[1].split(',')[0]
                    # Check if it needs to be converted to a size constant
                    size_name = convert_size_expression(size_expr)
                    output.append(f"        STRUCT    {label},{size_name}")
                elif directive == 'dcb.l' or directive == 'blk.l':
                    # Extract size - keep original expression and multiply by 4 for longwords
                    size_expr = parts[1].split(',')[0]
                    # Check if it needs to be converted to a size constant
                    size_name = convert_size_expression(size_expr)
                    # If it's a size constant name, wrap in parens; otherwise use as-is
                    if size_name != size_expr:
                        # It's a converted size constant
                        output.append(f"        STRUCT    {label},({size_name})*4")
                    else:
                        # It's an original expression like 54, keep it
                        output.append(f"        STRUCT    {label},({size_expr})*4")

                i += 1
                continue

        # Process variable definitions with labels
        # Labels can have ':' or just be followed by whitespace and a directive
        has_colon = ':' in line
        label = None

        if has_colon:
            label = line.split(':')[0].strip()
        elif line and not line[0].isspace() and original_line and not original_line[0].isspace():
            # Line starts at column 1 (no leading whitespace) - might be a label without colon
            # Check if next line has a directive
            if i + 1 < len(lines):
                next_line_raw = lines[i + 1]
                if next_line_raw and next_line_raw[0].isspace():
                    # Next line is indented, might be a directive
                    next_line_trimmed = next_line_raw.strip()
                    if ';' in next_line_trimmed:
                        next_line_trimmed = next_line_trimmed[:next_line_trimmed.index(';')].strip()
                    parts_check = next_line_trimmed.split()
                    if parts_check and parts_check[0].lower() in ['dc.l', 'dc.w', 'dc.b', 'dcb.b', 'dcb.l', 'blk.b', 'blk.l', 'ds.b']:
                        # Next line has a directive, so this is a label
                        label = line.strip()

        if label:
            # Strip s_ prefix if present (since 9_vars.s now has s_ prefixed labels)
            if label.startswith('s_'):
                label = label[2:]

            # Skip if it's a conditional
            if label in ['ifeq', 'ifne', 'endc', 'else']:
                # Output the conditional as-is
                output.append(f"    {original_line.strip()}")
                i += 1
                continue

            # Look ahead to find the directive
            directive_line = None
            directive_comment = comment  # Start with comment from label line
            j = i + 1

            # Check if directive is on same line (only possible if label had colon)
            if has_colon:
                rest = line.split(':', 1)[1].strip()
                if rest:
                    directive_line = rest
                    # Comment already captured from current line (label line)
                    j = i + 1

            # If not on same line, look at next line
            if not directive_line and j < len(lines):
                next_line = lines[j].strip()
                # Extract comment from next line (prefer it over label line comment)
                if ';' in next_line:
                    next_comment = next_line[next_line.index(';'):]
                    # Use directive line comment if present, otherwise keep label line comment
                    if next_comment:
                        directive_comment = next_comment
                    next_line = next_line[:next_line.index(';')].strip()
                if next_line and not next_line.startswith(';'):
                    directive_line = next_line
                    j += 1

            # If no directive found, or directive is EVEN/ALIGNWORD, treat as position marker (LABEL)
            if not directive_line or (directive_line and directive_line.upper() in ['EVEN', 'ALIGNWORD']):
                line = f"        LABEL     {label}"
                output.append(format_line_with_comment(line, directive_comment))
                i = j if directive_line else i + 1
                continue

            # Parse the directive
            parts = directive_line.split()
            if not parts:
                i += 1
                continue

            directive = parts[0].lower()

            # Handle different directives
            if directive == 'dcb.b' or directive == 'blk.b':
                # dcb.b size,value or blk.b size,value
                # Extract just the size (first part before comma)
                if len(parts) > 1:
                    size_expr = parts[1].split(',')[0]
                    # Check if it needs to be converted to a size constant
                    size_name = convert_size_expression(size_expr)
                    line = f"        STRUCT    {label},{size_name}"
                    output.append(format_line_with_comment(line, directive_comment))

            elif directive == 'dcb.l' or directive == 'blk.l':
                # dcb.l size,value or blk.l size,value (size in longwords)
                if len(parts) > 1:
                    size_expr = parts[1].split(',')[0]
                    # Check if it needs to be converted to a size constant
                    size_name = convert_size_expression(size_expr)
                    # If it's a size constant name, wrap in parens; otherwise use as-is
                    if size_name != size_expr:
                        # It's a converted size constant
                        line = f"        STRUCT    {label},({size_name})*4"
                    else:
                        # It's an original expression, keep it
                        line = f"        STRUCT    {label},({size_expr})*4"
                    output.append(format_line_with_comment(line, directive_comment))

            elif directive == 'ds.b':
                # ds.b size
                size_expr = parts[1]
                # Check if it needs to be converted to a size constant
                size_name = convert_size_expression(size_expr)
                line = f"        STRUCT    {label},{size_name}"
                output.append(format_line_with_comment(line, directive_comment))

            elif directive.startswith('dc.l'):
                # Count how many values
                values_str = directive_line[4:].strip()
                if values_str:
                    count = values_str.count(',') + 1
                    if count == 1:
                        line = f"        LONG      {label}"
                    else:
                        line = f"        STRUCT    {label},{count}*4"
                else:
                    line = f"        LONG      {label}"
                output.append(format_line_with_comment(line, directive_comment))

            elif directive.startswith('dc.w'):
                # Count how many values
                values_str = directive_line[4:].strip()
                if values_str:
                    count = values_str.count(',') + 1
                    if count == 1:
                        line = f"        WORD      {label}"
                    else:
                        line = f"        STRUCT    {label},{count}*2"
                else:
                    line = f"        WORD      {label}"
                output.append(format_line_with_comment(line, directive_comment))

            elif directive.startswith('dc.b'):
                # Count how many values or string length
                values_str = directive_line[4:].strip()
                if values_str:
                    count = count_dc_b_size(values_str)
                    if count == 1:
                        line = f"        BYTE      {label}"
                    else:
                        line = f"        STRUCT    {label},{count}"
                else:
                    line = f"        BYTE      {label}"
                output.append(format_line_with_comment(line, directive_comment))

            i = j
            continue

        # Handle standalone directives (not after a label)
        if line.lower() == 'even':
            output.append("        ALIGNWORD")
            i += 1
            continue

        i += 1

    # Add final marker
    output.append("")
    output.append("    LABEL     Globals_SIZEOF")
    output.append("")

    return '\n'.join(output)

def generate_validation_tests(globals_content):
    """Generate validation tests for all non-anonymous variables"""

    validation = []
    validation.append(";")
    validation.append("; Validation file for Globals structure")
    validation.append("; This file verifies that globals.i matches the label layout")
    validation.append(";")
    validation.append("")

    # Track conditional depth and current conditionals
    in_conditional = False
    conditional_stack = []

    # Extract all variable names from globals.i (skip anonymous ones)
    for line in globals_content.split('\n'):
        line_stripped = line.strip()

        # Skip comments, empty lines, and structure definitions
        if not line_stripped or line_stripped.startswith(';') or line_stripped.startswith('STRUCTURE') or line_stripped.startswith('include'):
            continue

        # Handle conditionals
        parts = line_stripped.split()
        if parts:
            first_word = parts[0]

            # Check for conditional directives
            if first_word in ['ifeq', 'ifne']:
                # Start of conditional block
                validation.append(f"    {line_stripped}")
                conditional_stack.append(line_stripped)
                in_conditional = True
                continue
            elif first_word == 'endc':
                # End of conditional block
                if conditional_stack:
                    conditional_stack.pop()
                    validation.append(f"    {line_stripped}")
                    if not conditional_stack:
                        in_conditional = False
                continue
            elif first_word == 'else':
                validation.append(f"    {line_stripped}")
                continue

            # Look for variable definitions (skip anonymous ones)
            if len(parts) >= 2:
                var_type = parts[0]  # LONG, WORD, BYTE, STRUCT, LABEL, ALIGNWORD

                if var_type in ['LONG', 'WORD', 'BYTE', 'STRUCT', 'LABEL']:
                    # Extract just the variable name (remove any size or additional info)
                    var_name_with_extras = parts[1]

                    # Remove trailing comma and size for STRUCT (e.g., "b2dTemp,2*4" -> "b2dTemp")
                    var_name = var_name_with_extras.split(',')[0]

                    # Skip anonymous variables and special markers
                    if var_name.startswith('_pad') or var_name in ['Globals_SIZEOF']:
                        continue

                    # Generate validation test comparing unprefixed structure against s_ labels
                    validation.append(f"    IFNE ({var_name}-V)-(s_{var_name}-s_V)")
                    validation.append(f'        FAIL "Offset mismatch: {var_name}"')
                    validation.append("    ENDIF")
                    validation.append("")

    return '\n'.join(validation)

def add_s_prefix_to_9_vars():
    """Add s_ prefix to all variable labels in 9_vars.s"""

    with open('9_vars.s', 'r') as f:
        lines = f.readlines()

    output = []
    in_vars_section = False

    for i, line in enumerate(lines):
        original_line = line.rstrip('\n')
        line_stripped = line.strip()

        # Skip empty lines and pure comments
        if not line_stripped or line_stripped.startswith(';'):
            output.append(original_line)
            continue

        # Check for start of variables section
        if line_stripped.startswith('Variables:'):
            in_vars_section = True
            output.append(original_line.replace('Variables:', 's_Variables:'))
            continue

        # V: is special - it's the base, add s_ prefix
        if line_stripped == 'V:':
            in_vars_section = True
            output.append(original_line.replace('V:', 's_V:'))
            continue

        # Check for EndData - this is where we stop
        if line_stripped.startswith('EndData:'):
            output.append(original_line.replace('EndData:', 's_EndData:'))
            continue

        # Check for C marker (end of variables, before data sections)
        if in_vars_section and line_stripped.startswith('C:'):
            output.append(original_line.replace('C:', 's_C:'))
            continue

        if not in_vars_section:
            output.append(original_line)
            continue

        # Handle conditionals - pass through unchanged
        first_word = line_stripped.split()[0] if line_stripped.split() else ''
        if first_word in ['ifeq', 'ifne', 'endc', 'else']:
            output.append(original_line)
            continue

        # Check if line starts at column 1 (potential label)
        if original_line and not original_line[0].isspace():
            # Check for label with colon
            if ':' in line_stripped:
                label = line_stripped.split(':')[0].strip()

                # Skip if already has s_ prefix
                if label.startswith('s_'):
                    output.append(original_line)
                    continue

                # Add s_ prefix to the label
                rest_of_line = original_line.split(':', 1)[1] if ':' in original_line else ''
                output.append(f"s_{label}:{rest_of_line}")
            else:
                # Label without colon - check if next line has directive
                if i + 1 < len(lines):
                    next_line_raw = lines[i + 1]
                    # Check if next line is indented (starts with whitespace)
                    if next_line_raw and next_line_raw[0].isspace():
                        # Next line is indented - this is likely a label
                        next_line_clean = next_line_raw.split(';')[0].strip()
                        parts = next_line_clean.split()
                        if parts and parts[0].lower() in ['dc.l', 'dc.w', 'dc.b', 'dcb.b', 'dcb.l', 'blk.b', 'blk.l', 'ds.b']:
                            # This is a label without colon
                            label = line_stripped
                            # Skip if already has s_ prefix
                            if label.startswith('s_'):
                                output.append(original_line)
                                continue
                            # Add s_ prefix
                            output.append(f"s_{label}")
                            continue

                # Not a label, pass through
                output.append(original_line)
        else:
            # Line doesn't start at column 1 - not a label
            output.append(original_line)

    # Write back to 9_vars.s
    with open('9_vars.s', 'w') as f:
        f.write('\n'.join(output) + '\n')

if __name__ == '__main__':
    # First, add s_ prefix to labels in 9_vars.s
    add_s_prefix_to_9_vars()
    print("Updated 9_vars.s with s_ prefix")

    # Generate the structure
    result = parse_9_vars()
    with open('globals.i', 'w') as f:
        f.write(result)
    print("Generated globals.i")

    # Generate validation tests
    validation = generate_validation_tests(result)
    with open('validate_globals.s', 'w') as f:
        f.write(validation)
    print("Generated validate_globals.s")
