/**
 * Returns a table with contents from your selected Dropbox folder. The optional
 * field 'folder' allows you to access sub-folders within the main folder.
 * 
 * @categories dropbox
 * @author https://github.com/ImkeF
 * @source https://github.com/ImkeF/M
 * @license MIT (c) 2017 Imke Feldmann
 * @version 2021-02-09-1
 */
let
  Source = (token as text, optional folder as text) =>
    let
      data = [
        path                                = if folder = null then "" else folder,
        recursive                           = false,
        include_media_info                  = false,
        include_deleted                     = false,
        include_has_explicit_shared_members = false
      ],
      header = [#"Authorization" = "Bearer " & token, #"Content-Type" = "application/json"],
      response = Web.Contents(
        "https://api.dropboxapi.com/2/files/list_folder",
        [Content = Json.FromValue(data), Headers = header]
      ),
      out = Json.Document(response, 1252),
      entries = out[entries],
      ToTable = Table.FromList(entries, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
      ExpandProperties = Table.ExpandRecordColumn(
        ToTable,
        "Column1",
        {
          ".tag",
          "name",
          "path_lower",
          "path_display",
          "id",
          "client_modified",
          "server_modified",
          "rev",
          "size",
          "content_hash"
        },
        {
          ".tag",
          "name",
          "path_lower",
          "path_display",
          "id",
          "client_modified",
          "server_modified",
          "rev",
          "size",
          "content_hash"
        }
      ),
      RetrieveContent = Table.AddColumn(
        ExpandProperties,
        "File",
        each Web.Contents(
          "https://content.dropboxapi.com/2/files/download",
          [
            Headers = [
              #"Dropbox-API-Arg" = "{""path"":""" & [path_display] & """}",
              #"Authorization"   = header[Authorization]
            ]
          ]
        )
      )
    in
      RetrieveContent,
  documentation = [
    Documentation.Name = "	AccessingData.DropboxFolder#(cr,lf)",
    Documentation.Description = "	Returns a table with contents from your selected Dropbox folder#(cr,lf)",
    Documentation.LongDescription
      = "	Returns a table with contents from your selected Dropbox folder. The optional field 'folder' allows you to access sub-folders within the main folder.#(cr,lf)",
    Documentation.Category = "	Accessing data functions#(cr,lf)",
    Documentation.Source = "	local#(cr,lf)",
    Documentation.Author = "	Imke Feldmann: www.TheBIccountant.com#(cr,lf)",
    Documentation.Examples = {
      [
        Description = "	#(cr,lf)",
        Code        = "	Check this blogpost explaining how it works: http://wp.me/p6lgsG-AA#(cr,lf) ",
        Result      = "	#(cr,lf)"
      ]
    }
  ]
in
  Value.ReplaceType(Source, Value.ReplaceMetadata(Value.Type(Source), documentation))
