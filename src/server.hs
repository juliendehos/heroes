
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

import App.Component
import App.Routes
import Server.Api

main :: IO ()
main = do
  port <- read . fromMaybe "3000" <$> lookupEnv "PORT"
  putStrLn $ "Running on port " <> show port <> "..."
  run port $ logStdout $ compress serverApp

  where
    compress = gzip def{gzipFiles = GzipCompress}

serverApp :: Application
serverApp = serve (Proxy @ServerApi) serverHandlers

newtype Page = Page HeroesComponent

type RoutesServer = Routes (Get '[HTML] Page)

type ServerApi
  =    StaticApi
  :<|> RoutesServer
  :<|> Raw

serverHandlers 
  =    serveDirectoryWith (defaultWebAppSettings "public")
  :<|> routesHandlersServer
  :<|> Tagged handle404

routesHandlersServer :: Server RoutesServer
routesHandlersServer 
  =    pure (Page $ heroesComponent uriHome)
  :<|> pure (Page $ heroesComponent uriAbout)
  :<|> pure (Page $ heroesComponent uri404)

handle404 :: Application
handle404 _ respond' =
  respond' $
    responseLBS status404 [("Content-Type", "text/html")] $
      toHtml $
        Page (heroesComponent uri404)

instance ToHtml Page where
  toHtml (Page x) =
    toHtml
      [ doctype_
      , html_
        [ lang_ "en" ]
        [ head_ []
          [ -- title_  [] [ text "Heroes" ]
           meta_ [ charset_ "utf-8" ]
          , meta_ [ name_ "viewport" , content_ "width=device-width, initial-scale=1" ]
          , link_
            [ rel_ "icon"
            , href_ "pub/favicon.ico"
            , type_ "image/x-icon"
            ]
          , script_ [ src_ "pub/index.js", type_ "module" ] ""
          , body_ [] [toView x]
          ]
        ]
      ]

