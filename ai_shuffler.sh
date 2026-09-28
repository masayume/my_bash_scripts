#!/bin/bash

## random prompt from the AI dir to regenerate image
# random .txt → extract prompt → clipboard via xclip → find matching image → display with feh

#!/bin/bash

line=$(grep "prompt:" *.txt | shuf -n 1)

txtfile="${line%%:prompt:*}"
prompt="${line#*:prompt:}"
base="${txtfile%.txt}"

# Find the corresponding image
image=""

for ext in jpg png webp; do
    if [[ -f "$base.$ext" ]]; then
        image="$base.$ext"
        break
    fi
done

if [[ -z "$image" ]]; then
    echo "No image found for: $txtfile" >&2
    exit 1
fi

# Show what was selected
echo "Image : $image"
echo "Prompt: $prompt"

# Prompt -> PRIMARY selection
printf '%s' "$prompt" | tee >(xclip -selection primary) >/dev/null

# Image filename -> CLIPBOARD
printf '%s' "$image" | xclip -selection clipboard

# Display image without blocking the shell
feh "$image" >/dev/null 2>&1 &

# line=$(grep "prompt:" *.txt | shuf -n1); txt="${line%%:prompt:*}"; printf '%s' "${line#*:prompt:}" | tee >(xclip -selection clipboard) >/dev/null; base="${txt%.txt}"; for e in jpg png webp; do [[ -f "$base.$e" ]] && { feh "$base.$e"; break; }; done

exit

## TODO: 
# 	1) use "tee" command to collect the random prompt and show the image via "feh"
# 	2) changedir
# 	3) git push this edit

# grep "prompt:" *.txt | shuf | tail -1 | awk -F':prompt: ' '{print $1; system("echo \"" $2 "\" | xclip -selection clipboard")}'

grep "prompt:" *.txt | shuf -n 1 |
awk -F':prompt: ' '{
    print $2 | tee >(xclip -selection clipboard);
    close("xclip -selection clipboard");
    print $1 > "/tmp/random_prompt_file"
}'

feh "$(cat /tmp/random_prompt_file | sed 's/\.txt$//' | sed -E 's/$/.(jpg|png|webp)/')"

