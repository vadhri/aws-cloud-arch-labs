import React, { useEffect, useState, View  } from 'react'
import Link from 'next/link'
import Head from '../components/head'
import Nav from '../components/nav'
import Datetime from 'react-datetime'
import Clock from 'react-live-clock';
import Flexbox from 'flexbox-react';
import data from '../static/countries.json'
import eu from '../static/europe.json'
import asia from '../static/asia.json'
import america from '../static/america.json'
import ReactCountryFlag from "react-country-flag";
import ReactTooltip from 'react-tooltip'

const Home = () => {
  const [date, setDate] = useState(null);

  function googlesyndication() {
    if (process.browser) {
      window.adsbygoogle = window.adsbygoogle || [];
      window.adsbygoogle.push({
        google_ad_client: "ca-pub-3162880262657619",
        enable_page_level_ads: true
      })
    }
  }


  const europe = []
  for (const [index, value] of eu.entries()) {
    europe.push(<Flexbox margin="10px 10px 10px 10px"
              flexGrow={1}
              key={value.tzonecode+index}
              flexWrap="wrap"
              flexDirection="column"
              border="1px solid black"
              justifyContent={'center'}>
              <div style={{width: "200px", fontSize: "18px", overflow: 'hidden', textOverflow: 'ellipsis'}}>
                <b>
                  <ReactCountryFlag code={value.cc}/>
                  {value.tzonecode}
                </b>
              </div>
              <Clock
                style={{fontSize: '1.5em'}}
                format={'HH:mm'}
                ticking={true}
                timezone={value.tzonecode} />
            </Flexbox>)
  }

  const as = []
  for (const [index, value] of asia.entries()) {
    as.push(<Flexbox margin="10px 10px 10px 10px"
              flexGrow={1}
              flexWrap="wrap"
              flexDirection="column"
              key={value.tzonecode+index}
              border="1px solid black"
              justifyContent={'center'}>
              <div style={{width: "200px", fontSize: "18px", overflow: 'hidden', textOverflow: 'ellipsis'}}>
                <b>
                  <ReactCountryFlag code={value.cc}/>
                  {value.tzonecode}
                </b>
              </div>
              <Clock
                style={{fontSize: '1.5em'}}
                format={'HH:mm'}
                ticking={true}
                timezone={value.tzonecode} />
            </Flexbox>)
  }


    const am = []
    for (const [index, value] of america.entries()) {
      am.push(<Flexbox margin="10px 10px 10px 10px"
                flexGrow={1}
                flexWrap="wrap"
                flexDirection="column"
                key={value.tzonecode+index}
                justifyContent={'center'}>
                <div style={{width: "300px", fontSize: "18px", overflow: 'hidden', textOverflow: 'ellipsis'}}>
                  <b>
                    <ReactCountryFlag style={{width: "20px"}}code={value.cc}/>
                    {value.tzonecode}
                  </b>
                </div>
                <Clock
                  style={{fontSize: '1.5em'}}
                  format={'HH:mm'}
                  ticking={true}
                  timezone={value.tzonecode} />
              </Flexbox>)
    }

  const items = []
  for (const [index, value] of data.entries()) {
    items.push(<Flexbox margin="10px 10px 10px 10px"
              flexGrow={1}
              flexWrap="wrap"
              flexDirection="column"
              key={value.tzonecode+index}
              alignContent="center"
              border="1px solid black"
              justifyContent={'center'}>
              <div style={{fontSize: "12px", width: "150px", overflow: 'hidden', textOverflow: 'ellipsis'}}>
              <b>
                <ReactCountryFlag style={{width: "20px"}}code={value.cc}/>
                {value.tzonecode}
              </b></div>
              <Clock
                style={{fontSize: '1.5em'}}
                format={'HH:mm'}
                ticking={true}
                timezone={value.tzonecode} />
            </Flexbox>)
  }
  googlesyndication();

  return (
    <div>
      <div className="hero">
      <h1 className="title">World clocks</h1>

      <Flexbox
        alignItems="center"
        padding="5px 5px 5px 5px"
        color="blue"
        flexGrow={1}
        flexWrap="wrap"
        flexDirection="column"
        justifyContent={'center'}>

        <div>{Intl.DateTimeFormat().resolvedOptions().timeZone}</div>
        <Clock className="title-text"
        interval={5000}
        format={'HH:mm'}
        width="auto"
        ticking={true}
        timezone={Intl.DateTimeFormat().resolvedOptions().timeZone} />
      </Flexbox>

      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 2
          }}
      />
      <h1 className="title-text">Europe</h1>
      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 1
          }}
      />
      <Flexbox flexDirection="row" flexWrap="wrap" justifyContent={'center'}>
        {europe}
      </Flexbox>

      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 2
          }}
      />

      <h1 className="title-text">Asia</h1>
      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 1
          }}
      />
      <Flexbox flexDirection="row" flexWrap="wrap" justifyContent={'center'}>
        {as}
      </Flexbox>

      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 2
          }}
      />

      <h1 className="title-text">America</h1>
      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 1
          }}
      />
      <Flexbox flexDirection="row" flexWrap="wrap" justifyContent={'center'}>
        {am}
      </Flexbox>


      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 2
          }}
      />
      <h1 className="title-text">All countries</h1>

      <hr
          style={{
              color: "blue",
              backgroundColor: "blue",
              height: 1
          }}
      />
      <Flexbox flexDirection="row" flexWrap="wrap" justifyContent={'center'}>
        {items}
      </Flexbox>
      </div>

      <style jsx>{`
        .hero {
          width: 100%;
          color: #333;
        }
        .title {
          margin: 0;
          width: 100%;
          padding-top: 10px;
          line-height: 1.15;
          font-size: 48px;
        }
        .title-text {
          margin: 0;
          width: 100%;
          line-height: 1.15;
          font-size: 30px;
          color: green;
        }
        .title-text,
        .title,
        .description {
          text-align: center;
        }
        .row {
          max-width: 880px;
          margin: 80px auto 40px;
          display: flex;
          flex-direction: row;
          justify-content: space-around;
        }
        .date {
          height: 24px;
          max-width: calc(100% - 32px)
          text-align: center;
          display: flex;
          align-items: center;
          justify-content: center;
          padding: 0 16px;
        }
        .date p {
          text-align: center;
        }
        .date span {
          width: 176px;
          text-align: center;
        }
        @keyframes Loading {
          0%{background-position:0% 50%}
          50%{background-position:100% 50%}
          100%{background-position:0% 50%}
        }
        .date .loading {
          max-width: 100%;
          height: 24px;
          border-radius: 4px;
          display: inline-block;
          background: linear-gradient(270deg, #D1D1D1, #EAEAEA);
          background-size: 200% 200%;
          animation: Loading 2s ease infinite;
        }
        .tzonecard {
          padding: 5px 5px 5px 5px;
          width: auto;
          text-align: center;
          color: blue;
          border: 1px solid #9b9b9b;
        }
      `}</style>
    </div>
  )
}

export default Home
