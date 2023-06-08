# Micro service for counting the token when sending prompt to OpenAI
Use [Office OpenAI token counter method](https://github.com/openai/openai-cookbook/blob/main/examples/How_to_count_tokens_with_tiktoken.ipynb)

## I. Installation
```shell
git clone git@gitlab.com:hapodigit/openai-token-counter.git
```

## II. Run in terminal
```shell
cd openai-token-counter
python main.py
```
### Change server port
```shell
export PORT=2223
python main.py
```

## III. Run in docker

Before build image or run docker container
```shell
cd openai-token-counter
chmod +x *.sh
```

### Build an image
```shell
./build_image.sh
```

### Running Docker container
```shell
./run_container.sh
```

## Test the request by curl command
```shell
curl -X 'POST' "http://127.0.0.1:9009/token/count" --data '{"message": "Hello world"}' -H "Content-Type: application/json;charset=utf-8"
```

You can pass `model` param to JSON data:
```json
{
  "message": "Hello world",
  "model": "gpt-3.5-turbo"
}
```

### Response on success
```json
{
    "success": true,
    "tokens": 7
}
```

### Response in any error
```json
{
    "code": 404,
    "message": "The requested URL was not found on the server. If you entered the URL manually please check your spelling and try again.",
    "success": false
}
```
## ALL DONE!