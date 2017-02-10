module Contact.Types exposing (..)

import Decoders exposing (ContactResponse)
import Http


type Msg
    = FetchContact Int
    | FetchContactResult (Result Http.Error ContactResponse)
