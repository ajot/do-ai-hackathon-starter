# 🚀 DigitalOcean Inference Quick Reference (cURL first, then Python)

Use these to sanity-check your keys and the endpoint fast. Then jump into Python.

---

## 1) cURL — Simple Chat (DigitalOcean Inference)

```bash
# Returns a short text completion from a chat model on DO
curl https://inference.do-ai.run/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITAL_OCEAN_MODEL_ACCESS_KEY" \
  -d '{
    "model": "llama3-8b-instruct",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Tell me a fun fact about octopuses."}
    ]
  }'
```

> Tip: Swap `llama3-8b-instruct` for any model you see in `/v1/models`.

---

## 2) cURL — Simple Image Gen (DigitalOcean Inference)

```bash
# Generates 1 image (1024x1024) and returns base64 JSON
curl https://inference.do-ai.run/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITAL_OCEAN_MODEL_ACCESS_KEY" \
  -d '{
    "model": "openai-gpt-image-1",
    "prompt": "A cute baby sea otter",
    "n": 1,
    "size": "1024x1024"
  }'
```

Optional: save directly to a PNG (requires `jq` + `base64`):

```bash
curl https://inference.do-ai.run/v1/images/generations \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $DIGITAL_OCEAN_MODEL_ACCESS_KEY" \
  -d '{
    "model": "openai-gpt-image-1",
    "prompt": "A cute baby sea otter",
    "n": 1,
    "size": "1024x1024"
  }' | jq -r '.data[0].b64_json' | base64 --decode > sea_otter.png
```

---

# Python Examples

## A) OpenAI SDK (pointing at DigitalOcean Inference)

### List Models

```python
from openai import OpenAI
from dotenv import load_dotenv
import os

load_dotenv()

client = OpenAI(
    base_url="https://inference.do-ai.run/v1/",
    api_key=os.getenv("DIGITAL_OCEAN_MODEL_ACCESS_KEY"),
)

models = client.models.list()
print("Available models:")
for m in models.data:
    print("-", m.id)
```

### Simple Chat

```python
from openai import OpenAI
from dotenv import load_dotenv
import os

load_dotenv()

client = OpenAI(
    base_url="https://inference.do-ai.run/v1/",
    api_key=os.getenv("DIGITAL_OCEAN_MODEL_ACCESS_KEY"),
)

resp = client.chat.completions.create(
    model="llama3-8b-instruct",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Tell me a fun fact about octopuses."}
    ],
)
print(resp.choices[0].message.content)
```

### Image Generation

```python
from openai import OpenAI
from dotenv import load_dotenv
import os, base64

load_dotenv()

client = OpenAI(
    base_url="https://inference.do-ai.run/v1/",
    api_key=os.getenv("DIGITAL_OCEAN_MODEL_ACCESS_KEY"),
)

result = client.images.generate(
    model="openai-gpt-image-1",
    prompt="A cute baby sea otter, children’s book drawing style",
    size="1024x1024",
    n=1,
)

b64 = result.data[0].b64_json
with open("sea_otter.png", "wb") as f:
    f.write(base64.b64decode(b64))

print("Saved sea_otter.png")
```

---

## B) Gradient SDK (native DigitalOcean client)

### Simple Chat

```python
from gradient import Gradient
from dotenv import load_dotenv
import os

load_dotenv()

client = Gradient(model_access_key=os.getenv("DIGITAL_OCEAN_MODEL_ACCESS_KEY"))

resp = client.chat.completions.create(
    model="llama3-8b-instruct",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Tell me a fun fact about octopuses."}
    ],
)

print(resp.choices[0].message.content)
```

### Image Generation

```python
from gradient import Gradient
from dotenv import load_dotenv
import os, base64

load_dotenv()

client = Gradient(model_access_key=os.getenv("DIGITAL_OCEAN_MODEL_ACCESS_KEY"))

result = client.images.generations.create(
    model="openai-gpt-image-1",
    prompt="A cute baby sea otter, children’s book drawing style",
    size="1024x1024",
    n=1,
)

b64 = result.data[0].b64_json
with open("sea_otter.png", "wb") as f:
    f.write(base64.b64decode(b64))

print("Saved sea_otter.png")
```

---

## Handy Differences (at a glance)

* **Auth env var**: `DIGITAL_OCEAN_MODEL_ACCESS_KEY`
* **DO endpoint (OpenAI SDK)**: `base_url="https://inference.do-ai.run/v1/"`
* **Image model IDs**:

  * OpenAI: `gpt-image-1`
  * DigitalOcean: `openai-gpt-image-1`
* **Images on DO**: include `n` and `size` explicitly.

---

If you want this as a one-page PDF handout, I can format it with headings and monospace styling.
