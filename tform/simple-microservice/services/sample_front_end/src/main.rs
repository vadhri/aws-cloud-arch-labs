use actix_web::{get, post, web, App, http, HttpResponse, HttpServer, Responder, Result};
use actix_web::client::Client;
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize, Debug)]
struct GenerateHashRequest {
    payload: String,
    passcode: String
}

#[derive(Serialize, Deserialize)]
struct GenerateHashResponse {
    hash: String,
    error: i32
}

#[derive(Serialize, Deserialize)]
struct GetStringRequest {
    hash: String,
    passcode: String
}

#[derive(Serialize, Deserialize)]
struct GetStringResponse {
    payload: String,
    error: i32
}

#[post("/getString")]
async fn get_string(req: web::Json<GetStringRequest>) -> impl Responder {
    println!("{:?} {:?}", req.hash, req.passcode);
    let client = Client::default();

    let onward_req = GetStringRequest {
        hash: req.hash.clone(),
        passcode: req.passcode.clone()
    };

    let response = client.post("http://db-service.internal:8080/getString")
        .content_type("application/json")
        .send_json(&onward_req)
        .await.unwrap()
        .body()
        .await
        .unwrap();       

    let mp = std::str::from_utf8(&response).unwrap().to_string();
    let mp_struct: GetStringResponse = serde_json::from_str(&mp).unwrap();

    HttpResponse::Ok()
        .content_type("text/json")
        .json(mp_struct)
}

#[post("/generate_hash")]
async fn generate_hash(req: web::Json<GenerateHashRequest>) -> impl Responder {
    println!("{:?} {:?}", req.payload, req.passcode);
    let client = Client::default();

    let onward_req = GenerateHashRequest {
        payload: req.payload.clone(),
        passcode: req.passcode.clone()
    };

   let response = client.post("http://db-service.internal:8080/generate_hash")
        .content_type("application/json")
        .send_json(&onward_req)
        .await.unwrap()
        .body()
        .await
        .unwrap();   

    let mp = std::str::from_utf8(&response).unwrap().to_string();
    let mp_struct: GenerateHashResponse = serde_json::from_str(&mp).unwrap();

    HttpResponse::Ok()
        .content_type("application/json")
        .json(mp_struct)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    println!("{:?}", "starting the server");
    HttpServer::new(|| {
        App::new()
            .service(get_string)
            .service(generate_hash)
    })
    .bind("0.0.0.0:8081")?
    .run()
    .await
}
