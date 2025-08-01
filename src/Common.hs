
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE TypeOperators              #-}

module Common where

import Data.Aeson (FromJSON, ToJSON)
import Data.Proxy (Proxy(..))
import GHC.Generics (Generic)
import Miso hiding (Capture)
import Miso.String (concat, MisoString, ms)
import Prelude hiding (concat)
-- import Network.URI (URI)
import Servant.API
import Servant.Links


-- model

data Hero = Hero
    { heroName :: MisoString
    , heroImage :: MisoString
    } deriving (Eq, Generic)

instance FromJSON Hero
instance ToJSON Hero

data Model = Model 
    { heroes_ :: [Hero]
    , uri_ :: URI
    } deriving (Eq)

initModel :: URI -> Model
initModel = Model []


-- actions

data Action
    = NoOp
    | PopHeroes
    | SetHeroes [Hero]
    | FetchHeroes
    | SetUri URI
    | ChangeUri URI
    deriving (Eq)


-- client routes

type HomeRoute = View Action
type AboutRoute = "about" :> View Action
type ClientRoutes = HomeRoute :<|> AboutRoute

homeRoute :: URI
homeRoute = linkURI $ safeLink (Proxy @ClientRoutes) (Proxy @HomeRoute)

aboutRoute :: URI
aboutRoute = linkURI $ safeLink (Proxy @ClientRoutes) (Proxy @AboutRoute)


-- common client/server routes 

type HeroesApi = "heroes" :>  Get '[JSON] [Hero] 
type AddApi = "add" :> Capture "x" Int :> Capture "y" Int :> Get '[JSON] Int
type StaticApi = "static" :> Raw 

type PublicApi = HeroesApi :<|> AddApi :<|> StaticApi 

linkHeroes :: URI
linkHeroes = linkURI $ safeLink (Proxy @PublicApi) (Proxy @HeroesApi)

linkAdd :: Int -> Int -> URI
linkAdd x y = linkURI (safeLink (Proxy @PublicApi) (Proxy @AddApi) x y)

linkStatic :: URI
linkStatic = linkURI $ safeLink (Proxy @PublicApi) (Proxy @StaticApi)

mkStatic :: MisoString -> MisoString
mkStatic filename = concat [ms $ show linkStatic, "/", filename]


-- views

clientViews :: (Model -> View Action) :<|> (Model -> View Action)
clientViews = homeView :<|> aboutView

{-
viewModel :: Model -> View Action
viewModel m = 
    case runRoute (Proxy @ClientRoutes) clientViews uri_ m of
        Left _ -> text "not found"
        Right v -> v
-}

homeView :: Model -> View Action
homeView m = div_ 
    []
    [ h1_ [] [ text "Heroes - Home" ]
    , button_ [ onClick $ ChangeUri aboutRoute ] [ text "About" ]
    , button_ [ onClick FetchHeroes ] [ text "FetchHeroes" ]
    , button_ [ onClick PopHeroes ] [ text "PopHeroes" ]
    , ul_ [] (map fmtHero $ heroes_ m)
    , p_ [] [ a_ [href_ $ ms $ show linkHeroes] [ text "GET: heroes" ] ] 
    , p_ [] [ a_ [href_ $ ms $ show $ linkAdd 20 22 ] [ text "GET: add 20 22" ] ] 
    ]
    where fmtHero h = li_ [] 
            [ text $ heroName h
            , br_ []
            , img_ [ src_ $ mkStatic (heroImage h) ]
            ]

aboutView :: Model -> View Action
aboutView _ = div_ 
    []
    [ h1_ [] [ text "Heroes - About" ]
    , button_ [ onClick $ ChangeUri homeRoute ] [ text "Home" ]
    , p_ [] [ text "This is an isomorphic web app implemented in Haskell !" ]
    ]



