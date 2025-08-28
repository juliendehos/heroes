{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}

module Server.Api where

import Data.Proxy
import Miso.Router qualified as R
import Miso.String
import Servant.API hiding (URI)
import Servant.Links hiding (URI)
import Servant.Miso.Router

import Domain.Hero (Hero)

type StaticApi = "pub" :> Raw
type HeroesApi = "heroes" :> Get '[JSON] [Hero]

type PublicApi = StaticApi :<|> HeroesApi

uriStatic, uriHeroes :: R.URI
uriStatic :<|> uriHeroes = 
  allLinks' toMisoURI (Proxy @PublicApi)

-- TODO
mkStaticUri :: MisoString -> MisoString
mkStaticUri filename = ms (show uriStatic) <> "/" <> filename

