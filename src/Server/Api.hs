{-# LANGUAGE OverloadedStrings #-}

module Server.Api where

import Data.Proxy
import Miso.String
import Servant.API
import Servant.Links

import Domain.Hero

type StaticApi = "pub" :> Raw
type HeroesApi = "heroes" :> Get '[JSON] [Hero]

type PublicApi = StaticApi :<|> HeroesApi

uriStatic, uriHeroes :: URI
uriStatic :<|> uriHeroes = allLinks' linkURI (Proxy @PublicApi)

mkStaticUri :: MisoString -> MisoString
mkStaticUri filename = ms (show uriStatic) <> "/" <> filename

