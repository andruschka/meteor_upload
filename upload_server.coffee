require = Npm.require
http = require 'http'
util = require 'util'
fs = require 'fs'
formidable = require 'formidable'
http.createServer((req, res) -> 
  if req.url is '/upload' and req.method.toLowerCase() is 'post'
    form = new formidable.IncomingForm()
    form.encoding = 'utf-8'
    form
      .on 'error', (err)->
        res.writeHead 200, {'content-type': 'text/plain'}
        res.end "error:\n\n#{util.inspect(err)}"
      .on 'end', ()->
        res.writeHead 200, {'content-type': 'text/plain'}
        res.end "successfully uploaded."              
    form.parse req, (err, fields, files) ->
      if files.fileToUpload        
        file = files.fileToUpload
        filename = file.name 
        # Pipe für den Datenfluss erstellen
        origData = fs.createReadStream file._writeStream.path
        # sofort das Ventil der Pipe schließen
        origData.pause()
        origData.on 'end', ()->            
          # Pipe ist leer 
          undefined
          
        # Eimer (Bild auf dem Server) für Daten aus der Pipe erstellen => WriteStream
        srvImageStream = fs.createWriteStream('./public/uploads/tmp_edit.jpg')         
        srvImageStream
          # Eimer ist erstellt und kann befüllt werden
          .on 'open', ()->
              # Pipe wird in den Eimer geleitet
              origData.pipe(srvImageStream)
              # Ventil der Pipe öffnen
              origData.resume()
  else
    res.writeHead 404, {'content-type': 'text/plain'}
    res.end '404'
).listen(3300)