
module Server.Api where

import Data.Proxy
import Servant.API
import Servant.Links

import Domain.Hero

type StaticApi = "pub" :> Raw

type HeroesApi = "heroes" :> Get '[JSON] [Hero]

uriStatic :: URI
uriStatic = allLinks' linkURI (Proxy @StaticApi)

uriHeroes :: URI
uriHeroes = allLinks' linkURI (Proxy @HeroesApi)

