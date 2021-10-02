// pub use GenerateHashRequest;
// pub use GenerateHashResponse;
// pub use GetStringRequest;
// pub use GetStringResponse;

use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize)]
pub struct GenerateHashRequest {
    pub payload: String,
    pub passcode: String
}

#[derive(Serialize, Deserialize)]
pub struct GenerateHashResponse {
    pub hash: String,
    pub error: i32
}

#[derive(Serialize, Deserialize)]
pub struct GetStringRequest {
    pub hash: String,
    pub passcode: String
}

#[derive(Serialize, Deserialize)]
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