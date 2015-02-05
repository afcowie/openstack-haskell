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

{-# LANGUAGE DeriveDataTypeable #-}
{-# OPTIONS_HADDOCK hide, prune #-}

module Cloud.OpenStack.Internal 
(
    CloudProblem(..),
    Username,
    Password,
    Tenancy,
    Credentials(..),
    URL,
    Token
)
where

import Control.Exception
import Network.Http.Streams (URL)

data CloudProblem
    = Unauthorized
    | ServiceFault Text
    | ServiceUnavailable Text
    deriving Typeable

instance Exception CloudProblem


type Username = String
type Password = String
type Tenancy  = String
data Credentials = Credentials Username Password Tenancy | ExistingToken ByteString Tenancy

data Token = Token {
    accessTokenId :: ByteString,
    accessTenancy :: Tenancy,  -- for convenience
    accessIdentity :: URL,     -- (the same as the originally supplied cluster endpoint)
    accessCompute :: URL,
    accessTelemetry :: URL,
    accessVolume :: URL,
    accessImage :: URL,
}

