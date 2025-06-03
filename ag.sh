#!/bin/bash

# Modify following configurations manually
api_url=""
model=""
api_key=""

prompt=""
if [[ $# -eq 1 ]];then
	prompt=$1
else
	echo -n "[User] "
	read prompt
fi

echo "[$model] "

# OpenAI compatible API
curl -s -N --request POST \
  --url $api_url \
  --header 'Authorization: Bearer '"$api_key"'' \
  --header 'Content-Type: application/json' \
  --data '{
  "model": "'$model'",
  "stream": true,
  "messages": [
    {
      "content": "'"$prompt"'",
      "role": "user"
    }
  ]
}' | while IFS= read -r line; do
	if [[ $line == data:* ]];then
		data=${line#data: }
		if [[ $data == "[DONE]" ]]; then
			break
		fi
		echo -E "$data" | jq -j -r '.choices[0].delta.content'
	fi
done