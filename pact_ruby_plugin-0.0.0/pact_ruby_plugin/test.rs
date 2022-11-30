use std::process::Command;

fn main() {
    let mut child = Command::new("bin/bundle")
    .arg("exec")
    .arg("ruby")
    .arg("main.rb")
    .spawn().unwrap();
    let _result = child.wait().unwrap();

    println!("reached end of main");
}
// fn main() {
//     let child = child_command
//     .stdout(Stdio::piped())
//     .stderr(Stdio::piped())
//     .spawn().context("Was not able to start plugin process")?;
//   let child_pid = child.id().unwrap_or_default();
//   debug!("Plugin {} started with PID {}", manifest.name, child_pid);

//   match ChildPluginProcess::new(child, manifest).await {
//     Ok(child) => Ok(PactPlugin::new(manifest, child)),
//     Err(err) => {
//       let mut s = System::new();
//       s.refresh_processes();
//       if let Some(process) = s.process(Pid::from_u32(child_pid)) {
//         process.kill_with(Signal::Term);
//       } else {
//         warn!("Child process with PID {} was not found", child_pid);
//       }
//       Err(err)
//     }
//   }

//     println!("reached end of main");
// }
