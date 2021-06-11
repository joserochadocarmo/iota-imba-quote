import './style'

tag App
	prop messages = []
	prop message

	def add
		send message if message.trim!.length > 5
		$message.value = ''

	def send message
		let res = await window.fetch('/send-message',
			method: 'post'
			headers: new Headers({'content-type': 'application/json'})
			body: JSON.stringify({message})
		)
		await res.json!
		load! if res.ok

	def load
		let res = await window.fetch '/get-all-messages'
		messages = await res.json!
		imba.commit!

	def setup
		load!

	css self d:flex fld:column pos:absolute inset:0 p:10px
	css a td:none
	css footer bg:gray2 p:3
	css .message flex:1 p:3 fs:md- bg:teal1
	css .teal
		bg:teal2 @hover:teal3 color:teal8 m:10px bxs:lg
		p:2 fw:500 rd:16px ta:center
	css form 
		d:flex fld:col p:2 m:0 mb:20px rd:16px
		
	<self>
		<form @submit.prevent.if(message)=add>
			<img src="https://logos-download.com/wp-content/uploads/2018/04/Miota_logo_black.svg" [w:75px pr:5px]>
			<input$message bind=message placeholder='Send Iota Quotes...' autofocus=yes maxLength=60 minLength=5>

		<div[flex:1 px:1 of:auto]> for {message,messageId} in messages
			<a href=`https://explorer.iota.org/mainnet/message/{messageId}` target="_blank"> 
				<div.teal> 
					<q> message 
					<small> "- @DocumentingIota"

		<footer>
			<span> "You have {messages.length} Quotes"

imba.mount <App>