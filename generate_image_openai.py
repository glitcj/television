from openai import OpenAI
import argparse
import requests
import uuid
import time

SAVE_TO = "./assets/images"
USE_UID = False
BATCH = False

def generate_image(args, query, api_key_):
    client = OpenAI(api_key=api_key_)

    response = client.images.generate(
      model="dall-e-3",
      prompt=query,
      size="1024x1024",
      quality="standard",
      n=1,
    )

    image_url = response.data[0].url

    # Download the image
    image_data = requests.get(image_url).content

    # Generate a unique identifier for the image
    uid = str(uuid.uuid4())

    # Save the image locally with the UID in the filename
    if args.batch > 1:
        file_name = f"image_{uid}.png"
    else:
        file_name = "generated_image.png"
    file_path = f"{SAVE_TO}/{file_name}"
    with open(file_path, "wb") as file:
        file.write(image_data)

    return file_name


def mask_image(args, query, api_key_):

    client = OpenAI(api_key=api_key_)
    response = client.images.generate(
      model="dall-e-3",
      prompt=query,
      size="1024x1024",
      quality="standard",
      n=1,
    )

    image_url = response.data[0].url

    # Download the image
    image_data = requests.get(image_url).content

    # Generate a unique identifier for the image
    uid = str(uuid.uuid4())

    # Save the image locally with the UID in the filename
    if args.batch > 1: 
        file_name = f"image_{uid}.png"
    else:
        file_name = "generated_image.png"
    file_path = f"{SAVE_TO}/{file_name}"
    with open(file_path, "wb") as file:
        file.write(image_data)

    return file_name


if __name__ == "__main__":
    # Parse command line arguments
    parser = argparse.ArgumentParser(description='Get an image from OpenAI.')
    parser.add_argument('--query', type=str, required=True, help='The query to send to the model.')
    parser.add_argument('--api_key', type=str, required=False, help='OPENAI_API_KEY.', default="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")
    parser.add_argument('--batch', type=int, required=False, help='.', default=1)
    parser.add_argument('--uid', type=bool, required=False, help='.', default=False)
    args = parser.parse_args()

    # Get the image and print the filename
    for i in range(args.batch):
        file_name = generate_image(args, args.query, args.api_key)
        time.sleep(1)

    print(file_name)

