import os
from flask import Flask
from flask import request
from flask import json
from flask import make_response
from werkzeug.exceptions import HTTPException
from count_token import num_tokens_from_messages
from waitress import serve
import base64

app = Flask(__name__)

@app.route("/token/count", methods=['POST'])
def count_token():
    response = make_response()
    response.content_type = "application/json;charset=utf-8;"
    response.data = json.dumps({
        "success": False,
        "message": "Something wrong!"
    })
    try:
        if request.is_json and request.json.get('messages'):
            messages = request.json.get('messages')
            model = request.json.get('model') or "gpt-3.5-turbo"
            if messages:
                messages = base64.b64decode(messages)
                messages = json.loads(messages)

                tokens = num_tokens_from_messages(messages, model)
                response.data = json.dumps({
                    "success": True,
                    "tokens": tokens
                })
        return response
    except NotImplementedError:
        return response

@app.errorhandler(HTTPException)
def handle_exception(e):
    """Return JSON instead of HTML for HTTP errors."""
    # start with the correct headers and status code from the error
    response = e.get_response()
    # replace the body with JSON
    response.data = json.dumps({
        "success": False,
        "code": e.code,
        "message": e.description,
    })
    response.content_type = "application/json;charset=utf-8;"
    return response

if __name__ == "__main__":
    port = int(os.environ.get('PORT', 9009))
    # app.run(debug=True, host='0.0.0.0', port=port)

    serve(app, host="0.0.0.0", port=port)