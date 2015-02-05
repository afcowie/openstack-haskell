--
-- Embedding OpenStack in Haskell
--
-- Copyright © 2014-2015 Anchor Systems Pty Ltd
--
-- The code in this file, and the program it is a part of, is
-- made available to you by its authors as open source software:
-- you can redistribute it and/or modify it under the terms of
-- the 3-clause BSD licence.
--

{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.ByteString.Char8 as S
import Cloud.OpenStack.Keystone
import Cloud.OpenStack.Nova


main :: IO ()
main = do
    let syd1 = "https://keystone.syd.opencloud.anchor.hosting:5000/v2.0"
    let auth = Credentials "afcowie" "stack123" "vaultaire"

    token <- requestToken syd1 auth
    
    result <- runExceptT $ do
        image <- viaGlance token $ do
            getImage "coreos"
        
        server <- viaNova token $ do
            listInstances
            createServer "vaultire-009" image

        -- other
        viaKeystone token $ do
            validateToken

    either throwIO print result


{-

main :: IO ()
main = do

    let syd1 = "https://keystone.syd.opencloud.anchor.hosting:5000/v2.0"
    let auth = Credentials "afcowie" "stack123" "vaultaire"

    withOpenStack syd1 auth $ do
        image <- getImage "coreos"
        createServerFromImage "vaultaire-010" image 
-}




