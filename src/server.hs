{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE PolyKinds                  #-}
{-# LANGUAGE TypeApplications           #-}
{-# LANGUAGE TypeOperators              #-}

import           Common
import           Data.Proxy (Proxy(..))
import qualified Lucid as L
import           Miso hiding (run)
import           Network.Wai.Handler.Warp (run)
import           Network.Wai.Middleware.RequestLogger (logStdout)
import           Servant


-- main program and data

main :: IO ()
main = do
  putStrLn "https://0.0.0.0:3000"
  run 3000 $ logStdout $ serve (Proxy @ServerApi) server

heroes :: [Hero]
heroes = 
    [ Hero "Scooby Doo" "scoobydoo.png"
    , Hero "Sponge Bob" "spongebob.png"
    ]


-- server api and app

type ServerApi
    =    HeroesApi
    :<|> AddApi
    :<|> StaticApi
--     :<|> ToServerRoutes ClientRoutes HtmlPage Action

server :: Server ServerApi
server 
    =    pure heroes
    :<|> (\ x y -> pure $ x + y)
    :<|> serveDirectoryFileServer "static"
--     :<|> (handleHome :<|> handleAbout)

handleHome :: Handler (HtmlPage (View Action))
handleHome = pure $ HtmlPage $ homeView $ initModel homeRoute

handleAbout :: Handler (HtmlPage (View Action))
handleAbout = pure $ HtmlPage $ aboutView $ initModel aboutRoute


-- view rendering

newtype HtmlPage a = HtmlPage a
    deriving (Show, Eq)

instance L.ToHtml a => L.ToHtml (HtmlPage a) where
    toHtmlRaw = L.toHtml
    toHtml (HtmlPage x) = L.doctypehtml_ $ do
        L.head_ $ do
            L.meta_ [L.charset_ "utf-8"]
            -- L.script_ [L.src_ (mkStatic "index.js")] 
        L.body_ (L.toHtml x)



