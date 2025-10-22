function uuid --description 'Generate a UUID and copy to clipboard'
    python3 -c "import sys,uuid; sys.stdout.write(str(uuid.uuid4()))" | pbcopy && pbpaste && echo
end
