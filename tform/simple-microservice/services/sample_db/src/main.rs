use actix_web::{get,post, web, App, HttpResponse, HttpServer, Responder};
use mysql::*;
use mysql::prelude::*;

use crypto_hash::{Algorithm, hex_digest};

mod structs;
use std::{thread, time};

use structs::*;

#[get("/")]
async fn healthcheck() -> impl Responder {
    HttpResponse::Ok()
    .content_type("application/json")
    .body("OK")    
}

#[post("/getString")]
async fn get_string(form: web::Json<GetStringRequest>, handles: web::Data<Dbhandles>) -> impl Responder {
    let mut conn = handles.db_pool_read.get_conn().unwrap();
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
async fn generate_hash(req: web::Json<GenerateHashRequest>, handles: web::Data<Dbhandles>) -> impl Responder {
    println!("[generate_hash] {:?} {:?}", req.payload, req.passcode);

    let digest = req.payload.clone();

    println!("[generate_hash] {:?} ", digest);

    let mut conn = handles.db_pool_write.get_conn().unwrap();
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

    println!("generate_hash {:?}", selected_payments);

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

    println!("[generate_hash] {:?}", o);

    HttpResponse::Ok()
        .content_type("application/json")
        .json(o)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("starting service.....");

    let url = "mysql://root:qwertyuiopasdf@rdsreplicadbservice.service._tcp.local:3306/test";
    let opts = Opts::from_url(url).unwrap();
    
    let db_status = false;

    while db_status == false {
        match Pool::new(opts.clone()) {
            Ok(_value) => {
                break;
            },
            _ => {
                let one_sec = time::Duration::from_millis(1000);
                thread::sleep(one_sec);
                println!("waiting for db connection.");
            }
        }
    }

    println!("Database connected.");

    let pool_read = Pool::new(opts).unwrap();
    
    let url_rw = "mysql://root:qwertyuiopasdf@rdsdbservice.service._tcp.local:3306/test";
    let opts_rw = Opts::from_url(url_rw).unwrap();
    let pool_rw = Pool::new(opts_rw).unwrap();

    let mut conn = pool_rw.get_conn().unwrap();

    // To init tables, table create could possibly be another script that launches into the private ec2 instance and does the operation at commandline. 
    // the following is also a method. 

    conn.query_drop(
        r"CREATE TABLE test (
            hash varchar(255),
            payload varchar(255),
            passcode varchar(255)
        )");

    HttpServer::new(move || {
        App::new()
            .data(Dbhandles {
                db_pool_read: pool_read.clone(),
                db_pool_write: pool_rw.clone()
            })
            .service(get_string)
            .service(healthcheck)
            .service(generate_hash)
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
