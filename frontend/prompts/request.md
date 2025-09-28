Now we need to make the submit button do something.

when the submit button is clicked, we need to:

- Make a post request to localhost:8000/pipeline.
- The request should have the format {"prompt": "example prompt"}. Pass the contents of the text box as the value for the prompt key.
- The /pipeline endpoint will return a payload in this format: {"result": {...}}. The 'result' key contains a string as value.
- Once we get the response from the POST request, show a modal window with the string contents from the 'result' key in the payload.