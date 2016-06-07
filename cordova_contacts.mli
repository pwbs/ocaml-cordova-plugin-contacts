(* -------------------------------------------------------------------------- *)
type field =
  | Addresses [@js "addresses"]
  | Birthday [@js "birthday"]
  | Categories [@js "categories"]
  | Country [@js "country"]
  | Department [@js "department"]
  | Display_name [@js "displayName"]
  | Emails [@js "emails"]
  | Family_name [@js "familyName"]
  | Formatted [@js "formatted"]
  | Given_name [@js "givenName"]
  | Honorific_prefix [@js "honorificPrefix"]
  | Honorific_suffix [@js "honorificSuffix"]
  | Id [@js "id"]
  | Ims [@js "ims"]
  | Locality [@js "locality"]
  | Middle_name [@js "middleName"]
  | Name [@js "name"]
  | Nickname [@js "nickname"]
  | Note [@js "note"]
  | Organizations [@js "organizations"]
  | Phone_numbers [@js "phoneNumbers"]
  | Photos [@js "photos"]
  | Postal_code [@js "postalCode"]
  | Region [@js "region"]
  | Street_address [@js "streetAddress"]
  | Title [@js "title"]
  | Urls [@js "urls"]
  [@@js.enum]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type error =
  | Unknown_error [@js 0]
  | Invalid_argument_error [@js 1]
  | Timeout_error [@js 2]
  | Pending_operation_error [@js 3]
  | Io_error [@js 4]
  | Not_supported_error [@js 5]
  | Operation_cancelled_error [@js 6]
  | Permission_denied_error [@js 20]
  [@@js.enum]

class contact_error : Ojs.t ->
  object
    inherit Ojs.obj
    method code : int
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class contact_field : Ojs.t ->
  object
    inherit Ojs.obj
    method type_        : string
    [@@js.get "type"]
    method value        : string
    method pref         : bool
  end

class contact_field_phone : Ojs.t ->
  object
    inherit contact_field
  end

class contact_field_email : Ojs.t ->
  object
    inherit contact_field
  end

class contact_field_ims : Ojs.t ->
  object
    inherit contact_field
  end

class contact_field_photo : Ojs.t ->
  object
    inherit contact_field
  end

class contact_field_category : Ojs.t ->
  object
    inherit contact_field
  end

class contact_field_url : Ojs.t ->
  object
    inherit contact_field
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class contact_name : Ojs.t ->
  object
    inherit Ojs.obj
    (* The complete name of the contact. *)
    method formatted         : string option
    (* The contact's family name. *)
    method family_name       : string option
    (* The contact's given name. *)
    method given_name        : string option
    (* The contact's middle name. *)
    method middle_name       : string option
    (* The contact's prefix (example Mr. or Dr.) *)
    method honorific_prefix  : string option
    (* The contact's suffix (example Esq.). *)
    method honorific_suffix  : string option
  end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class contact_address : Ojs.t ->
  object
    inherit Ojs.obj
    (* Set to true if this ContactAddress contains the user's preferred
     * value. *)
    method pref              : bool
    (* A string indicating what type of field this is, home for example. *)
    method type_              : string option
    [@@js.get "type"]
    (* The full address formatted for display. *)
    method formatted         : string option
    (* The full street address. *)
    method street_address    : string option
    (* The city or locality. *)
    method locality          : string option
    (* The state or region. *)
    method region            : string option
    (* The zip code or postal code. *)
    method postal_code       : string option
    (* The country name. *)
    method country           : string option
  end

val create_contact_address :
  ?pref:bool                    ->
  ?type_:string option          ->
  ?formatted:string option      ->
  ?street_address:string option ->
  ?locality:string option       ->
  ?region:string option         ->
  ?postal_code:string option    ->
  ?country:string option        ->
  unit                          ->
  contact_address
  [@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class contact_organization : Ojs.t ->
  object
    inherit Ojs.obj
    (* Set to true if this ContactOrganization contains the user's preferred
     * value. *)
    method pref              : bool
    (* A string that indicates what type of field this is, home for example. *)
    method type_             : string option
    (* The name of the organization. *)
    method name              : string option
    (* The department the contract works for. *)
    method department        : string option
    (* The contact's title at the organization. *)
    method title             : string option
  end

val create_contact_organization :
  ?pref:bool                    ->
  ?type_:string option          ->
  ?name:string option           ->
  ?department:string option     ->
  ?title:string option          ->
  unit                          ->
  contact_organization
  [@@js.builder]

(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class contact : Ojs.t ->
  object
    inherit Ojs.obj
    (* A globally unique identifier. *)
    method id                      : string option
    (* The name of this Contact, suitable for display to end users. *)
    method display_name             : string option
    (* An object containing all components of a persons name. *)
    method name                    : contact_name option
    (* A casual name by which to address the contact. *)
    method nick_name               : string option
    (* An array of all the contact's phone numbers. *)
    method phone_numbers           : contact_field_phone array option
    (* An array of all the contact's email addresses. *)
    method emails                  : contact_field_email array option
    (* An array of all the contact's addresses. *)
    method addresses                : contact_address array option
    (* An array of all the contact's IM addresses. *)
    method ims                     : contact_field_ims array option
    (* An array of all the contact's organizations. *)
    method organizations           : contact_organization array option
    (* The birthday of the contact. *)
    (* Js_date is defined in the binding of the javascript standard library. See
     * documentation *)
    method birthday                : Js_date.t option
    (*  A note about the contact. *)
    method note                    : string option
    (* An array of the contact's photos. *)
    method photos                  : contact_field_photo array option
    (* An array of all the user-defined categories associated with the contact.
     * *)
    method categories              : contact_field_category array option
    (* An array of web pages associated with the contact. *)
    method urls                    : contact_field_url array option

    (* Returns a new Contact object that is a deep copy of the calling object,
     * with the id property set to null.
     * clone [contact]
     * *)
    method clone                   : contact -> contact
    (* Removes the contact from the device contacts database, otherwise executes
     * an error callback with a ContactError object.
     * remove [success_callback] [error_callback]
     * *)
    method remove                  : (unit -> unit)           ->
                                     (contact_error -> unit)  ->
                                     unit
    (* Saves a new contact to the device contacts database, or updates an
     * existing contact if a contact with the same id already exists.
     * save [success_callback] [error_callback]
     * *)
    method save                    : (contact -> unit)        ->
                                     (contact_error -> unit)  ->
                                     unit
  end

val create_contact :
  ?display_name:string option                       ->
  ?name:contact_name option                         ->
  ?nick_name:string option                          ->
  ?phone_numbers:contact_field_phone array option   ->
  ?emails:contact_field_email array option          ->
  ?addresses:contact_address array option           ->
  ?ims:contact_field_ims array option               ->
  ?organizations:contact_organization array option  ->
  ?birthday:Js_date.t option                     ->
  ?note:string option                               ->
  ?photos:contact_field_photo array option          ->
  ?categories:contact_field_category array option   ->
  ?urls:contact_field_url array option              ->
  unit                                              ->
  contact
  [@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class contact_find_options : Ojs.t ->
  object
    inherit Ojs.obj
    method filter                  : string
    method multiple                : bool
    method desired_fields          : string array option
    method has_phone_number        : bool
  end

val create_contact_find_options :
  ?filter:(string [@js.default ""])                                 ->
  ?multiple:(bool [@js.default false])                              ->
  ?desired_fields:(field array option [@js.default None])  ->
  ?has_phone_number:(bool [@js.default false])                      ->
  unit                                                              ->
  contact_find_options
[@@js.builder]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
class contacts : Ojs.t ->
  object
    inherit Ojs.obj
    (* ---------------------------------------------------------------------- *)
    (* The navigator.contacts.create method is synchronous, and returns a new
     * Contact object.
     * This method does not retain the Contact object in the device contacts
     * database, for which you need to invoke the Contact.save method. *)
    method create           : unit -> contact
    (* ---------------------------------------------------------------------- *)

    (* ---------------------------------------------------------------------- *)
    (* This method executes asynchronously, querying the device contacts database and
     * returning an array of Contact objects. The resulting objects are passed
     * to the contactSuccess callback function specified by the contactSuccess
     * parameter. *)
    (* find [fields] [success_callback] *)
    method find             : string array            ->
                              (contact array -> unit) ->
                              unit
    (* find [fields] [success_callback] [error_callback] *)
    method find_err         : string array            ->
                              (contact array -> unit) ->
                              (string -> unit)        ->
                              unit
    [@@js.call "find"]
    (* find [fields] [success_callback] [error_callback] [find_options] *)
    method find_opt         : string                  ->
                              (contact array -> unit) ->
                              (string -> unit)        ->
                              contact_find_options    ->
                              unit
    [@@js.call "find"]
    (* ---------------------------------------------------------------------- *)

    (* ---------------------------------------------------------------------- *)
    (* The navigator.contacts.pickContact method launches the Contact Picker to
     * select a single contact. The resulting object is passed to the
     * contactSuccess callback function specified by the contactSuccess
     * parameter. *)
    (* pick_contact [success_cb] *)
    method pick_contact     : (contact -> unit) ->
                              unit

    (* pick_contact [success_cb] [error_cb] *)
    method pick_contact_err : (contact -> unit) ->
                              (string -> unit)  ->
                              unit
    [@@js.call "pickContact"]
    (* ---------------------------------------------------------------------- *)
  end
(* -------------------------------------------------------------------------- *)


(* -------------------------------------------------------------------------- *)
val t : unit -> contacts
[@@js.get "navigator.contacts"]
(* -------------------------------------------------------------------------- *)
