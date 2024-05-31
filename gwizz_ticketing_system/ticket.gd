@tool
extends Control

var url = "http://70.92.29.228:1477/upload"

@onready var description = $Description
@onready var email = $Email
@onready var result_field = $Result


@onready var http_request = $HTTPRequest

func _ready():
	http_request.request_completed.connect(_on_request_completed)
	
func _on_submit_pressed():
	if description.text == "":
		description.placeholder_text = "Describe your problem: \n(This can't be blank!)"
		return
	
	if email.text == "":
		email.placeholder_text = "Email \n(This can't be blank!)"
		return 
	
	var data_to_send = {'desc' : description.text, "email" : email.text}
	
	var json = JSON.stringify(data_to_send)
	var headers = ["Content-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	
	description.text = ""
	email.text = ""

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	
	match json["status"]:
		"0":
			result_field.text = str("Ticket submitted!\nHere is your\nTicket ID:\n",  json["id"])
		"1":
			result_field.text = str("Sorry! Email already has an open ticket\nTicket ID:\n",  json["id"])
		_:
			result_field.text = str("ok something really weird happened. The only value the server can send back is either a 0, or a 1. And somehow you got neither. I'd suggest contacting a priest or the government or something idk.")
	
	
	result_field.show()
