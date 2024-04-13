import base64

# Accept user input for the SHA value
raw_input = input("Enter the SHA value (looks like 'sha256-XXXX='): ").strip()

# Check if 'sha-' prefix is present and strip it if found
parsed = raw_input.replace("sha256-", "")

# Convert the input to bytes
converted = parsed.encode()

# Convert to hex
print(base64.decodebytes(converted).hex())
