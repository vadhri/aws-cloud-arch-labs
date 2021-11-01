import React from 'react'
import NextHead from 'next/head'
import { string } from 'prop-types'

const defaultDescription = ''
const defaultOGURL = ''
const defaultOGImage = ''

const Head = props => (
  <NextHead>
    <meta charSet="UTF-8" />
    <title>World clocks</title>
    <meta key="google-site-verification" name="google-site-verification" content="5tEC1Trp0t85wCcFXIx4KT1DKvULdWSBEa7SI8AsPjw" />
    <script data-ad-client="ca-pub-8623291681603519" src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js"></script>
  </NextHead>
)

Head.propTypes = {
  title: string,
  description: string,
  url: string,
  ogImage: string
}

export default Head
