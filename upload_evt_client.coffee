onDragEnter = (e)->
  e.stopPropagation()
  e.preventDefault()

onDragOver = (e) ->
  e.stopPropagation()
  e.preventDefault()
  $("#drop").addClass("entered")
onDragLeave = (e) ->
  e.stopPropagation()
  e.preventDefault()
  $("#drop").removeClass("entered")
onDrop = (e)->
  $("#drop").removeClass("entered")
  e.stopPropagation()
  e.preventDefault()
  file = e.dataTransfer.files[0]
  data2send = new FormData()
  data2send.append 'fileToUpload', file
  xhr = new XMLHttpRequest()
  xhr.open "POST", "http://#{location.hostname}:3300/upload", true
  xhr.onreadystatechange = ()->
    if xhr.readyState is 4
      console.log ":-) log kommt noch"   
  xhr.send data2send

# events an div anhängen  
Template.content.rendered = ()->
  upload = document.getElementById 'drop'
  upload.addEventListener 'dragenter', onDragEnter, false
  upload.addEventListener 'dragover', onDragOver, false
  upload.addEventListener 'dragleave', onDragLeave, false
  upload.addEventListener 'drop', onDrop, false