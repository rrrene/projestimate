# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
#Try to generate a token with : rand(36**100).to_s(36)
#ProjestimateMaquette::Application.config.secret_token = 7cbc7c878c74038fe1abb93824841b8e2fbeca4a2fbf86985efd9f446f48fa4f545226e42457c93b97ae1423cba052a463f330d884ca6fa356e9f7e437050557
ProjestimateMaquette::Application.config.secret_token = SETTINGS['SECRET_TOKEN']
