const fs = require('fs')
const path = require('path')
const origen = './CR'
const destino = './CR'
const tipos = ['FN','IF','P','TF','TR','V']


tipos.forEach(tipo => {

	let listaOrigen = fs.readdirSync(path.join(origen,tipo)).filter(x => path.extname(x) === '.sql')
	let listaModificados = fs.readdirSync(path.join(destino,tipo+' MODIFICADOS')).filter(x => path.extname(x) === '.sql')
	listaModificados.forEach(item => {
		//if(item === 'test.sql'){
		let textoModificado = fs.readFileSync(path.join(destino,tipo+' MODIFICADOS',item)).toString()
		let result = textoModificado
			.replace(/with\s*\(\s*(nolock|rowlock)\s*\)/gim,'')
			.replace(/\s+/gm,'')
			.toLowerCase()

		let textoOriginal = fs.readFileSync(path.join(origen,tipo,item))
			.toString()
			.replace(/with\s*\(\s*(nolock|rowlock)\s*\)/gim,'')
			.replace(/\s+/gm,'')
			.toLowerCase()
		if(result!==textoOriginal){
			console.log(result===textoOriginal, item)
		}
		// fs.appendFileSync('origen.sql', textoOriginal)
		// fs.appendFileSync('destino.sql', result)
		// }
	})
})
