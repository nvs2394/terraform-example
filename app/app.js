const express = require('express')
const app = express()
const port = 8080

app.get('/v1/status', (_, res) => {
	res.jsonp({"status": "ok"})
})

app.get('/customers', (_, res) => {
  res.jsonp([
	{
		"name": "Igor Price",
		"phone": "(623) 371-2421",
		"postalZip": "354602",
		"region": "Salzburg",
		"numberrange": 8,
		"email": "magna.ut@yahoo.com",
		"address": "925-6426 Sed Av.",
		"country": "Canada",
		"list": 17
	},
	{
		"name": "Dante Sherman",
		"phone": "(462) 589-7667",
		"postalZip": "8353",
		"region": "Vienna",
		"numberrange": 7,
		"email": "ridiculus.mus@hotmail.net",
		"address": "Ap #529-4507 Enim, Ave",
		"country": "Colombia",
		"list": 9
	},
	{
		"name": "Violet Hudson",
		"phone": "1-420-336-2186",
		"postalZip": "10516",
		"region": "Viken",
		"numberrange": 4,
		"email": "ac.risus.morbi@outlook.net",
		"address": "7468 Velit Rd.",
		"country": "Nigeria",
		"list": 19
	},
	{
		"name": "Acton Potts",
		"phone": "(827) 455-2353",
		"postalZip": "318388",
		"region": "Saint Petersburg City",
		"numberrange": 3,
		"email": "pellentesque.ut@hotmail.com",
		"address": "Ap #729-5629 Dapibus Av.",
		"country": "Colombia",
		"list": 3
	},
	{
		"name": "Montana Alvarez",
		"phone": "(338) 851-3163",
		"postalZip": "12875",
		"region": "Luxemburg",
		"numberrange": 2,
		"email": "ipsum.primis.in@icloud.org",
		"address": "P.O. Box 694, 6805 Rutrum Av.",
		"country": "Canada",
		"list": 7
	}
])
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})