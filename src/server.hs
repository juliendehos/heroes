{-# LANGUAGE OverloadedStrings #-}

{-# OPTIONS_GHC -fno-warn-orphans #-}

import Data.Maybe (fromMaybe)
import Miso hiding (run)
import Network.HTTP.Types
import Network.Wai (responseLBS)
import Network.Wai.Application.Static (defaultWebAppSettings)
import Network.Wai.Handler.Warp (run)
import Network.Wai.Middleware.Gzip (GzipFiles (..), def, gzip, gzipFiles)
import Network.Wai.Middleware.RequestLogger (logStdout)
import Servant
import System.Environment (lookupEnv)

import App.Component (HeroesComponent, heroesComponent)
import App.Routes (Routes, uriHome, uriAbout, uri404)
import Domain.Hero (Hero(..))
import Server.Api (PublicApi, mkStaticUri)

-------------------------------------------------------------------------------
-- server data
-------------------------------------------------------------------------------

heroes :: [Hero]
heroes = 
    [ Hero "Scooby Doo" "scoobydoo.png"
    , Hero "Sponge Bob" "spongebob.png"
    ]

-------------------------------------------------------------------------------
-- server routing
-------------------------------------------------------------------------------

handlePublicApi :: Server PublicApi
handlePublicApi 
  =    serveDirectoryWith (defaultWebAppSettings "public")
  :<|> pure heroes

type ClientRoutesServer = Routes (Get '[HTML] Page)

type ServerApi
  =    PublicApi
  :<|> ClientRoutesServer
  :<|> Raw

newtype Page = Page HeroesComponent

handleClientRoutes :: Server ClientRoutesServer
handleClientRoutes 
  =    pure (Page $ heroesComponent uriHome)
  :<|> pure (Page $ heroesComponent uriAbout)
  :<|> pure (Page $ heroesComponent uri404)

handle404 :: Application
handle404 _ respond' =
  respond' $
    responseLBS status404 [("Content-Type", "text/html")] $
      toHtml $
        Page (heroesComponent uri404)

-------------------------------------------------------------------------------
-- server rendering
-------------------------------------------------------------------------------

instance ToHtml Page where
  toHtml (Page x) =
    toHtml
      [ doctype_
      , html_
        [ lang_ "en" ]
        [ head_ 
          [ title_ "Heroes" ]
          [ meta_ [ charset_ "utf-8" ]
          , meta_ [ name_ "viewport" , content_ "width=device-width, initial-scale=1" ]
          , link_
            [ rel_ "icon"
            , href_ (mkStaticUri "favicon.ico")
            , type_ "image/x-icon"
            ]
          , script_ [ src_ (mkStaticUri "index.js"), type_ "module" ] ""
          , body_ [] [toView x]
          ]
        ]
      ]

-------------------------------------------------------------------------------
-- run server app
-------------------------------------------------------------------------------

main :: IO ()
main = do
  print $ mkStaticUri "favicon.ico"
  port <- read . fromMaybe "3000" <$> lookupEnv "PORT"
  putStrLn $ "Running on port " <> show port <> "..."
  run port $ logStdout $ compress serverApp
  where
    compress = gzip def{gzipFiles = GzipCompress}

serverApp :: Application
serverApp = serve (Proxy @ServerApi) serverHandlers
  where
    serverHandlers 
      =    handlePublicApi
      :<|> handleClientRoutes
      :<|> Tagged handle404

