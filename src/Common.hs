{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeOperators #-}

module Common where

import           Control.Monad.State
import           Data.Bool
import           Data.Proxy
import           Servant.API
import           Servant.Links

import           Miso
import           Miso.String
import qualified Miso.Style as CSS

-- | Model
data Model = Model
    { uri :: URI
    , navMenuOpen :: Bool
    }
    deriving (Show, Eq)

-- | Event Actions
data Action
    = ChangeURI URI
    | HandleURI URI
    | ToggleNavMenu
    deriving (Show, Eq)

-- | Routes (server / client agnostic)
type Home a = a
type The404 a = "404" :> a
type Community a = "community" :> a

-- | Routes skeleton
type Routes a
  =    Home a
  :<|> Community a
  :<|> The404 a

-- | Client routing
type ClientRoutes = Routes (View Action)

-- | Server routing
type ServerRoutes = Routes (Get '[HTML] Page)

-- | Component synonym
type HeroesComponent = Component Model Action

-- | Links
uriHome, uriCommunity, uri404 :: URI
uriHome :<|> uriCommunity :<|> uri404 = 
  allLinks' linkURI (Proxy @ClientRoutes)

-- | Page for setting HTML doctype and header
newtype Page = Page HeroesComponent

-- | Client Handlers
clientHandlers
  ::   (Model -> View Action)
  :<|> (Model -> View Action)
  :<|> (Model -> View Action)
clientHandlers
  =    home
  :<|> community
  :<|> the404

heroesComponent :: URI -> HeroesComponent
heroesComponent uri =
  (app uri)
    { subs = [ uriSub HandleURI ]
    , logLevel = DebugAll
    }

app :: URI -> Component Model Action
app currentUri = component emptyModel updateModel viewModel
  where
    emptyModel = Model currentUri False
    viewModel m =
        case route (Proxy :: Proxy ClientRoutes) clientHandlers uri m of
          Left _ -> the404 m
          Right v -> v

updateModel :: Action -> Effect Model Action
updateModel = \case
  HandleURI u ->
    modify $ \m -> m { uri = u }
  ChangeURI u -> do
    modify $ \m -> m { navMenuOpen = False }
    io_ (pushURI u)
  ToggleNavMenu -> do
    m@Model{..} <- get
    put m { navMenuOpen = not navMenuOpen }

-- | Views
community :: Model -> View Action
community = template v
  where
    v =
        div_
            [class_ "animated fadeIn"]
            [ a_
                [href_ "https://github.com/dmjio/miso"]
                [ img_
                    [ width_ "100"
                    , class_ "animated bounceInDown"
                    , src_ misoSrc
                    , alt_ "miso logo"
                    ]
                ]
            , h1_
                [ class_ "title animated pulse"
                , CSS.style_
                    [ CSS.fontSize "82px"
                    , CSS.fontWeight "100"
                    ]
                ]
                [text "community"]
            , h2_
                [class_ "subtitle animated pulse"]
                [ a_
                    [ href_ "https://github.com/haskell-miso"
                    , target_ "_blank"
                    ]
                    [ text "GitHub"
                    ]
                , text " / "
                , a_
                    [ href_ "https://matrix.to/#/#haskell-miso:matrix.org"
                    , target_ "_blank"
                    ]
                    [ text "Matrix.org"
                    ]
                , text " / "
                , a_
                    [ href_ "https://www.irccloud.com/invite?channel=%23haskell-miso&hostname=irc.libera.chat&port=6697&ssl=1"
                    , target_ "_blank"
                    ]
                    [ text "#haskell-miso"
                    ]
                , text " / "
                , a_
                    [ href_ "https://discord.gg/QVDtfYNSxq"
                    , target_ "_blank"
                    ]
                    [ text "Discord"
                    ]
                ]
            ]

misoSrc :: MisoString
misoSrc = "static/miso.png"

home :: Model -> View Action
home = template v
  where
    v =
        div_
            [class_ "animated fadeIn"]
            [ a_
                [href_ "https://github.com/dmjio/miso"]
                [ img_
                    [ width_ "100"
                    , class_ "animated bounceInDown"
                    , src_ misoSrc
                    , alt_ "miso logo"
                    ]
                ]
            , h1_
                [ class_ "title animated pulse"
                , CSS.style_
                    [ CSS.fontSize "82px"
                    , CSS.fontWeight "100"
                    ]
                ]
                [text "miso"]
            , h2_
                [class_ "subtitle animated pulse"]
                [ text "A tasty "
                , a_
                    [ href_ "https://www.haskell.org/"
                    , rel_ "noopener"
                    , target_ "_blank"
                    ]
                    [ strong_ [] [text "Haskell"]
                    ]
                , text " web and mobile framework"
                ]
            ]

template :: View Action -> Model -> View Action
template content Model{..} =
    div_
        []
        [ a_
            [ class_ "github-fork-ribbon left-top fixed"
            , href_ "http://github.com/dmjio/miso"
            , prop "data-ribbon" ("Fork me on GitHub" :: MisoString)
            , target_ "blank"
            , rel_ "noopener"
            , title_ "Fork me on GitHub"
            ]
            [text "Fork me on GitHub"]
        , hero content uri navMenuOpen
        ]

the404 :: Model -> View Action
the404 = template v
  where
    v =
        div_
            []
            [ a_
                [href_ "https://github.com/dmjio/miso"]
                [ img_
                    [ width_ "100"
                    , class_ "animated bounceOutUp"
                    , src_ misoSrc
                    , alt_ "miso logo"
                    ]
                ]
            , h1_
                [ class_ "title"
                , CSS.style_
                    [ CSS.fontSize "82px"
                    , CSS.fontWeight "100"
                    ]
                ]
                [text "404"]
            , h2_
                [class_ "subtitle animated pulse"]
                [ text "No soup for you! "
                , a_ [href_ "/", onPreventClick (ChangeURI uriHome)] [text " - Go Home"]
                ]
            ]

-- | Hero
hero :: View Action -> URI -> Bool -> View Action
hero content uri' navMenuOpen' =
    section_
        [class_ "hero is-medium is-primary is-bold has-text-centered"]
        [ div_
            [class_ "hero-head"]
            [ header_
                [class_ "nav"]
                [ div_
                    [class_ "container"]
                    [ div_
                        [class_ "nav-left"]
                        [ a_ [class_ "nav-item"] []
                        ]
                    , span_
                        [ class_ $ "nav-toggle " <> bool mempty "is-active" navMenuOpen'
                        , onClick ToggleNavMenu
                        ]
                        [ span_ [] []
                        , span_ [] []
                        , span_ [] []
                        ]
                    , div_
                        [class_ $ "nav-right nav-menu " <> bool mempty "is-active" navMenuOpen']
                        [ div_
                            [ classList_
                                [ ("nav-item", True)
                                ]
                            ]
                            [ a_
                                [ href_ $ ms (uriPath uriHome)
                                , onPreventClick (ChangeURI uriHome)
                                , classList_
                                    [ ("is-active", uriPath uri' == "")
                                    ]
                                ]
                                [ text "Home"
                                ]
                            ]

                        , div_
                            [ classList_
                                [ ("nav-item", True)
                                ]
                            ]
                            [ a_
                                [ href_ $ ms (uriPath uriCommunity)
                                , onPreventClick (ChangeURI uriCommunity)
                                , classList_
                                    [ ("is-active", uriPath uri' == uriPath uriCommunity)
                                    ]
                                ]
                                [text "Community"]
                            ]
                        ]
                    ]
                ]
            ]
        , div_
            [class_ "hero-body"]
            [ div_
                [class_ "container"]
                [ content
                ]
            ]
        ]

onPreventClick :: Action -> Attribute Action
onPreventClick action =
    onWithOptions
        defaultOptions{preventDefault = True}
        "click"
        emptyDecoder
        (\() -> const action)

