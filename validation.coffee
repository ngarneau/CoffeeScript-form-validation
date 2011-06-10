$(document).ready ->

  ###
  RegEx
  ###
  emailRegEx = new RegExp("^[-_.a-z0-9]+@[-_a-z0-9]+\.[a-z]{2,4}$")
  emptyRegEx = new RegExp("[-_.a-zA-Z0-9]{3,}")
  numberRegEx = new RegExp("^[0-9]{3,}$")
  postalCodeRegEx = new RegExp("^[A-Z]{1}[0-9]{1}[A-Z]{1} [0-9]{1}[A-Z]{1}[0-9]{1}") 
  
  ###
  Error Messages (French/English)
  ###
  errorMessages = []
  errorMessages[$('#nom').attr("id")] = if langue is "fr" then "Le nom est invalide." else "Last name is invalid."
  errorMessages[$('#prenom').attr("id")] = if langue is "fr" then "Le prénom est invalide." else "First name is invalid."
  errorMessages[$('#institution').attr("id")] = if langue is "fr" then "L'institution est invalide." else "Institution is invalid."
  errorMessages[$('#adresse').attr("id")] = if langue is "fr" then "L'adresse est invalide." else "Address is invalid."
  errorMessages[$('#ville').attr("id")] = if langue is "fr" then "La ville est invalide." else "City is invalid."
  errorMessages[$('#courriel').attr("id")] = if langue is "fr" then "Le courriel est invalide. ex.: info@domain.ca" else "Email is invalid. ex.: info@domain.ca"
  errorMessages[$('#code').attr("id")] = "ex.: A1A 1A1"
  errorMessages[$('#province').attr("id")] = if langue is "fr" then "Sélectionnez une province." else "Select a province."
  errorMessages[$('#couverture').attr("id")] = if langue is "fr" then "Ajouter une couverture." else "Add a cover."
  errorMessages[$('#cv').attr("id")] = if langue is "fr" then "Ajouter votre C.V." else "Add your C.V."
  errorMessages[$('#lettre-resp').attr("id")] = if langue is "fr" then "Ajouter votre lettre." else "Add your lettre."

  ###
  Arrays of inputs, by types
  ###
  inputs = []
  emails = []
  codes = []
  selects = []
  numbers = []

  ###
  Fetching and sorting all form inputs
  ###
  allinputs = $(".validate").filter(":input")
  for input in allinputs
    if $(input).hasClass("text")
      inputs.push($(input))
    if $(input).hasClass("email")
      emails.push($(input))
    if $(input).hasClass("code")
      codes.push($(input))
    if $(input).hasClass("select")
      selects.push($(input))
    if $(input).hasClass("number")
      numbers.push($(input))
  
  ###
  Inputs onblur validation
  ###
  for input in inputs
    input.blur () ->
      validateInputs($(this), emptyRegEx)
  
  ###
  Email onblur validation
  ###
  for email in emails
    email.blur () ->
      validateInputs($(this), emailRegEx)

  ###
  Postal Code onblur validation
  ###
  for code in codes
    code.blur () ->
      validateInputs($(this), postalCodeRegEx)

  ###
  Selects onchange validation
  ###
  for select in selects
    select.change () ->
      validateSelect($(this))

  ###
  Numbers onblur validation
  ###
  for number in numbers
    number.blur () ->
      validateInputs($(this), numberRegEx)
  

  validateForm = () ->
    $.extend(badFields = [], validateInputs(inputs, emptyRegEx), validateInputs(emails, emailRegEx), validateInputs(codes, postalCodeRegEx), validateSelect(selects), validateInputs(numbers, numberRegEx))
    if badFields.length is 0
      valid = true
    else
      valid = false
    return valid
  
  validateInputs = (inputs, regex) ->
    error = []
    for input in inputs
      if regex.test($(input).val())
        removeErrorStyle(input)
      else
        error.push($(input).attr("id"))
        addErrorStyle(input)
    return error

  validateSelect = (selects) ->
    error = []
    for select in selects
      if $(select).val() isnt "0"
        removeErrorStyle(select)
      else
        error.push($(select).attr("id"))
        addErrorStyle(select)
      return error
  
  ###
  Error Styling, I changed the border of the input and put an error message within a span in the label of the same input, it's opt to you.
  ###
  addErrorStyle = (element) ->
    $(element).addClass('form-error')
    $(element).prev('label').find('.error-message').html(errorMessages[$(element).attr("id")])

  removeErrorStyle = (element) ->
    $(element).removeClass('form-error')
    $(element).prev('label').find('.error-message').html("")

  $('#adhesion').submit ->
    return validateForm()
  
    
