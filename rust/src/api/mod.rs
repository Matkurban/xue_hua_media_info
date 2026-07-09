pub mod frb_handler;
pub mod parser;
pub mod parser_async;
pub mod reader;
pub mod reader_async;
pub mod types;

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
