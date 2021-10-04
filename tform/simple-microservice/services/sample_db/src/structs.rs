// pub use GenerateHashRequest;
// pub use GenerateHashResponse;
// pub use GetStringRequest;
// pub use GetStringResponse;

use serde::{Serialize, Deserialize};

use mysql::*;
use mysql::prelude::*;

#[derive(Debug)]
pub struct Dbhandles {
    pub db_pool_read: mysql::Pool,
    pub db_pool_write: mysql::Pool
}


#[derive(Serialize, Deserialize, Debug)]
pub struct GenerateHashRequest {
    pub payload: String,
    pub passcode: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GenerateHashResponse {
    pub hash: String,
    pub error: i32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetStringRequest {
    pub hash: String,
    pub passcode: String
}

#[derive(Serialize, Deserialize, Debug)]
pub struct GetStringResponse {
    pub payload: String,
    pub error: i32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DbRecordRead {
    pub payload: String,
    pub error: i32
}

#[derive(Serialize, Deserialize, Debug)]
pub struct DbRecordWrite {
    pub payload: String,
    pub hash: String, 
    pub passcode: String
}
