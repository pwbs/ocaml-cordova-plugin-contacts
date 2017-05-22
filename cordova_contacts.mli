(* -------------------------------------------------------------------------- *)
type field =
  | Addresses        [@js "addresses" ]
  | Birthday         [@js "birthday"  ]
  | Categories       [@js "categories"]
  | Country          [@js "country"]
  | Department       [@js "department"]
  | Display_name     [@js "displayName"]
  | Emails           [@js "emails"]
  | Family_name      [@js "familyName"]
  | Formatted        [@js "formatted"]
  | Given_name       [@js "givenName"]
  | Honorific_prefix [@js "honorificPrefix"]
  | Honorific_suffix [@js "honorificSuffix"]
  | Id               [@js "id"]
  | Ims              [@js "ims"]
  | Locality         [@js "locality"]
  | Middle_name      [@js "middleName"]
  | Name             [@js "name"]
  | Nickname         [@js "nickname"]
  | Note             [@js "note"]
  | Organizations    [@js "organizations"]
  | Phone_numbers    [@js "phoneNumbers"]
  | Photos           [@js "photos"]
  | Postal_code      [@js "postalCode"]
  | Region           [@js "region"]
  | Street_address   [@js "streetAddress"]
  | Title            [@js "title"]
  | Urls             [@js "urls"]
  [@@js.enum]
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
type error =
  | Unknown_error             [@js  0]
  | Invalid_argument_error    [@js  1]
  | Timeout_error             [@js  2]
  | Pending_operation_error   [@js  3]
  | Io_error                  [@js  4]
  | Not_supported_error       [@js  5]
  | Operation_cancelled_error [@js  6]
  | Permission_denied_error   [@js 20]
  [@@js.enum]

module ContactError: sig
  type t
  val code : t -> error [@@js.get]
end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
module ContactField: sig
  type t
  val type_: t -> string [@@js.get "type"]
  val value: t -> string [@@js.get]
  val pref : t -> bool   [@@js.get]
end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
module ContactName: sig
  type t
  val formatted        : t -> string option [@@js.get]
  val family_name      : t -> string option [@@js.get]
  val given_name       : t -> string option [@@js.get]
  val middle_name      : t -> string option [@@js.get]
  val honorific_prefix : t -> string option [@@js.get]
  val honorific_suffix : t -> string option [@@js.get]
end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
module ContactAddress: sig
  type t
  val create_contact_address :
    (* Set to true if this ContactAddress contains the user's preferred
     * value. *)
    ?pref:bool                    ->
    (* A string indicating what type of field this is, home for example. *)
    ?type_:(string [@js "type"])  ->
    (* The full address formatted for display. *)
    ?formatted:string             ->
    (* The full street address. *)
    ?street_address:string        ->
    (* The city or locality. *)
    ?locality:string              ->
    (* The state or region. *)
    ?region:string                ->
    (* The zip code or postal code. *)
    ?postal_code:string           ->
    (* The country name. *)
    ?country:string               ->
    unit                          ->
    t
  [@@js.builder]

  val pref              : t -> bool
  val type_             : t -> string option [@@js.get "type"]
  val formatted         : t -> string option
  val street_address    : t -> string option
  val locality          : t -> string option
  val region            : t -> string option
  val postal_code       : t -> string option
  val country           : t -> string option
end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
module ContactOrganization: sig
  type t
  val create_contact_organization :
    (* Set to true if this ContactOrganization contains the user's preferred
     * value. *)
    ?pref:bool                    ->
    (* A string that indicates what type of field this is, home for example. *)
    ?type_:string option          ->
    (* The name of the organization. *)
    ?name:string option           ->
    (* The department the contract works for. *)
    ?department:string option     ->
    (* The contact's title at the organization. *)
    ?title:string option          ->
    unit                          ->
    t
  [@@js.builder]

  val pref       : t -> bool
  val type_      : t -> string option
  val name       : t -> string option
  val department : t -> string option
  val title      : t -> string option
end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)

module Contact : sig
  type t

  val create_contact :
    ?display_name:string                       ->
    ?name:ContactName.t                        ->
    ?nick_name:string                          ->
    ?phone_numbers:ContactField.t list         ->
    ?emails:ContactField.t list                ->
    ?addresses:ContactAddress.t list           ->
    ?ims:ContactField.t list                   ->
    ?organizations:ContactOrganization.t list  ->
    ?birthday:Js_date.t                        ->
    ?note:string                               ->
    ?photos:ContactField.t list                ->
    ?categories:ContactField.t list            ->
    ?urls:ContactField.t list                  ->
    unit                                       ->
    t
  [@@js.builder]

  (* A globally unique identifier. *)
  val id            : string option
  (* The name of this Contact, suitable for display to end users. *)
  val display_name  : string option
  (* An object containing all components of a persons name. *)
  val name          : ContactName.t option
  (* A casual name by which to address the contact. *)
  val nick_name     : string option
  (* An array of all the contact's phone numbers. *)
  val phone_numbers : ContactField.t list option
  (* A list of all the contact's email addresses. *)
  val emails        : ContactField.t list option
  (* A list of all the contact's addresses. *)
  val addresses     : ContactAddress.t list option
  (* A list of all the contact's IM addresses. *)
  val ims           : ContactField.t list option
  (* A list of all the contact's organizations. *)
  val organizations : ContactOrganization.t list option
  (* The birthday of the contact. *)
  (* Js_date is defined in the binding of the javascript standard library.
     * https://github.com/dannywillems/ocaml-js-stdlib
     * See documentation *)
  val birthday      : Js_date.t option
  (*  A note about the contact. *)
  val note          : string option
  (* A list of the contact's photos. *)
  val photos        : ContactField.t list option
  (* A list of all the user-defined categories associated with the contact. *)
  val categories    : ContactField.t list option
  (* A list of web pages associated with the contact. *)
  val urls          : ContactField.t list option

  val clone         : t -> t
  (* Removes the contact from the device contacts database, otherwise executes
     * an error callback with a ContactError object.
     * remove [success_callback] [error_callback]
     * *)
  val remove        : (unit -> unit)            ->
                      (ContactError.t -> unit)  ->
                      unit
  (* Saves a new contact to the device contacts database, or updates an
     * existing contact if a contact with the same id already exists.
     * save [success_callback] [error_callback]
     * *)
  val save          : (t -> unit)               ->
                      (ContactError.t -> unit)  ->
                      unit
end
(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
module ContactFindOptions: sig
  type t

  val create_contact_find_options :
    ?filter            : (string [@js.default ""])                ->
    ?multiple          : (bool [@js.default false])               ->
    ?desired_fields    : (field list option [@js.default None])   ->
    ?has_phone_number  : (bool [@js.default false])               ->
    unit                                                          ->
    t
  [@@js.builder]

  val filter           : t -> string
  val multiple         : t -> bool
  val desired_fields   : t -> string list option
  val has_phone_number : t -> bool
end

(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
module Contacts: sig
  type t
  (* ---------------------------------------------------------------------- *)
  (* The navigator.contacts.create method is synchronous, and returns a new
   * Contact object.
   * This method does not retain the Contact object in the device contacts
   * database, for which you need to invoke the Contact.save method. *)
  val create           : ?contact:Contact.t -> unit -> Contact.t
  (* ---------------------------------------------------------------------- *)

  (* ---------------------------------------------------------------------- *)
  (* This val executes asynchronously, querying the device contacts
   * database and returning an list of Contact objects.
   * The resulting objects are passed to the contactSuccess callback
   * function specified by the contactSuccess
   * parameter. *)
  (* find [fields] [success_callback] *)
  val find             : string list              ->
                         (Contact.t list -> unit) ->
                         unit

  (* find [fields] [success_callback] [error_callback] *)
  val find_err         : string list              ->
                         (Contact.t list -> unit) ->
                         (string -> unit)         ->
                         unit
  [@@js.call "find"]

  (* find [fields] [success_callback] [error_callback] [find_options] *)
  val find_opt         : string                    ->
                         (Contact.t list -> unit)  ->
                         (string -> unit)          ->
                         ContactFindOptions.t      ->
                         unit
  [@@js.call "find"]
  (* ---------------------------------------------------------------------- *)

  (* ---------------------------------------------------------------------- *)
  (* The navigator.contacts.pickContact method launches the Contact Picker to
   * select a single contact. The resulting object is passed to the
   * contactSuccess callback function specified by the contactSuccess
   * parameter. *)
  (* pick_contact [success_cb] *)
  val pick_contact     : (Contact.t -> unit) ->
    unit

  (* pick_contact [success_cb] [error_cb] *)
  val pick_contact_err : (Contact.t -> unit) ->
    (string -> unit)  ->
    unit
  [@@js.call "pickContact"]

  (* ---------------------------------------------------------------------- *)
end
[@js.scope "navigator.contacts"]
