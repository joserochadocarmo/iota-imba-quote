import express from 'express'
import index from './index.html'
import { SingleNodeClient, Converter,INDEXATION_PAYLOAD_TYPE,MAX_NUMBER_PARENTS } from "@iota/iota.js"

const app = express!
app.use express.json!
const client = new SingleNodeClient('https://chrysalis-nodes.iota.org')
const INDEX = 'quote-iota'

app.get('/') do |req,res|
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)
	res.send index.body

app.get('/get-all-messages') do |req,res|
	let messagesFromTangle = await client.messagesFind(Converter.utf8ToBytes(INDEX))
	# map every message to the promise of the fetch in parallel
	let promisesMessages = messagesFromTangle.messageIds.map do |messageId| get-message messageId
	let messages = await Promise.all promisesMessages 
	res.send messages

def get-message messageId
	let message = await client.message(messageId)
	{ messageId, message: Converter.hexToUtf8 message.payload.data }


app.post('/send-message') do |req,res|
	let tipsResponse = await client.tips!
	let submitMessage =
		parentMessageIds: tipsResponse.tipMessageIds.slice(0,MAX_NUMBER_PARENTS)
		payload:
			type: INDEXATION_PAYLOAD_TYPE
			index: Converter.utf8ToHex(INDEX)
			data: Converter.utf8ToHex(req.body.message.substring(0, 60))
	let messageId = await client.messageSubmit(submitMessage)
	res.send({result: messageId})

imba.serve app.listen(process.env.PORT or 3001)