text = 'computics';
binary_string = '';

for i = 1:length(text)
    % Convert the character to its ASCII value
    ascii_value = uint8(text(i));
    
    % Convert the ASCII value to its binary representation
    binary_value = dec2bin(ascii_value);
    
    % Append the binary value to the binary_string
    binary_string = [binary_string, binary_value];
end

disp(['Binary representation of "computics": ', binary_string]);
%%
text = 'computics';
hex_string = '';

for i = 1:length(text)
    % Convert the character to its ASCII value
    ascii_value = uint8(text(i));
    
    % Convert the ASCII value to its hexadecimal representation
    hex_value = dec2hex(ascii_value);
    
    % Append the hex value to the hex_string
    hex_string = [hex_string, hex_value];
end

disp(['Hexadecimal representation of "computics": ', hex_string]);

