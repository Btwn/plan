const fs = require('fs')
const path = require('path')
const origen = './'
const destino = './'
const tipos = ['FN','IF','P','TF','TR','V']


tipos.forEach(tipo => {

	let listaOrigen = fs.readdirSync(path.join(origen,tipo)).filter(x => path.extname(x) === '.sql')
	let listaModificados = fs.readdirSync(path.join(destino,tipo+' MODIFICADOS')).filter(x => path.extname(x) === '.sql')
	listaModificados.forEach(item => {
		let textoModificado = fs.readFileSync(path.join(destino,tipo+' MODIFICADOS',item)).toString()
		let result = textoModificado.replace(/with\s*\(\s*(nolock|rowlock)\s*\)/gim,'').replace(/\s+/gm,'').toLowerCase()

		let textoOriginal = fs.readFileSync(path.join(origen,tipo,item)).toString().replace(/\s+/gm,'').toLowerCase()
		if(result!==textoOriginal){
			console.log(result===textoOriginal, item)
		}

	})
})
