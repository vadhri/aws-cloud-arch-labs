use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder, Result};
use mysql::*;
use mysql::prelude::*;

use crypto_hash::{Algorithm, hex_digest};

mod structs;
use std::{thread, time};

use structs::*;

#[post("/getString")]
async fn get_string(form: web::Json<GetStringRequest>, db_pool: web::Data<mysql::Pool>) -> impl Responder {
    let mut conn = db_pool.get_conn().unwrap();
    let mut query = "SELECT hash, payload, passcode from test WHERE hash='".to_owned();
    
    query.push_str(&form.hash.to_string());
    query.push_str(&"' AND passcode='");
    query.push_str(&form.passcode.to_string());
    query.push_str("';");

    let selected_payments = conn
    .query_map(
        query,
        |(hash, payload, passcode)| {
            DbRecordWrite { hash, payload, passcode }
        },
    ).unwrap();

    if selected_payments.len() == 0 {
        let resp = GetStringResponse {
            payload: "No records.".to_string(),
            error: -1
        };
    
        HttpResponse::Ok()
            .content_type("application/json")
            .json(resp)        
    } else {
        let resp = GetStringResponse {
            payload: selected_payments[0].payload.to_string(),
            error: 0
        };
    
        HttpResponse::Ok()
            .content_type("application/json")
            .json(resp)
    }
}

#[post("/generate_hash")]
async fn generate_hash(req: web::Json<GenerateHashRequest>, db_pool: web::Data<mysql::Pool>) -> impl Responder {
    let digest = hex_digest(Algorithm::SHA256, req.payload.as_bytes());
    let mut conn = db_pool.get_conn().unwrap();
    let mut query = "SELECT hash, payload, passcode from test WHERE hash='".to_owned();
    query.push_str(&digest.to_string());
    query.push_str(&"';");

    let selected_payments = conn
        .query_map(
            query,
            |(hash, payload, passcode)| {
                DbRecordWrite { hash, payload, passcode }
            },
        ).unwrap();

    if selected_payments.len() == 0 {
        conn.exec_batch(
            r"INSERT INTO test (payload, passcode, hash)
              VALUES (:payload, :passcode, :hash)",
            [ params! {
                "payload" => &req.payload,
                "passcode" => &req.passcode,
                "hash" => digest.clone(),
            }]
        ).unwrap();
    } 

    let o = GenerateHashResponse {
        error: 0,
        hash: digest
    };

    HttpResponse::Ok()
        .content_type("application/json")
        .json(o)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("starting service.....");

    let url = "mysql://XXXXXXXX:XXXXXXXX@XXXXXXXX:3306/XXXXXXXX";
    let opts = Opts::from_url(url).unwrap();
    

    let db_status = false;

    while db_status == false {
        match Pool::new(opts.clone()) {
            Ok(x) => {
                break;
            },
            _ => {
                let one_sec = time::Duration::from_millis(1000);
                thread::sleep(one_sec);
                println!("waiting for db connection.");
            }
        }
    }

    println!("Database connected....");

    let pool = Pool::new(opts).unwrap();

    HttpServer::new(move || {
        App::new()
            .data(pool.clone())
            .service(get_string)
            .service(generate_hash)
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
