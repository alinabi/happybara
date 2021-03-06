{-# LANGUAGE OverloadedStrings #-}

import           Happybara
import           Happybara.WebKit
import           Happybara.WebKit.Server

import           Control.Monad.Base

import qualified Data.ByteString.Char8 as BS
import           Data.Text             as T
import           Data.Text.Encoding    as T

import qualified System.IO             as IO

main :: IO ()
main = run $ do
    visit "http://google.com"

    btn <- findOrFail (button "I'm Feeling Lucky" [disabled False])
    SingleValue value <- getValue btn
    puts $ T.concat [ "Button found: ", value ]

    click btn

    url <- currentUrl
    puts $ T.concat [ "New url: ", url ]

    return ()

run :: Happybara Session a -> IO a
run act = do
    serverPath <- webkitServerPath
    withSession serverPath $ \sess ->
        runHappybara sess act

puts :: Text -> Happybara sess ()
puts txt =
    liftBase $ BS.hPutStrLn IO.stdout $ T.encodeUtf8 txt
