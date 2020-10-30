// get access to all Electron API
const electron = require('electron')
// module to control the app life cycle
const app = electron.app
// module for the menu
const Menu = electron.Menu
// module to create native browser window
const BrowserWindow = electron.BrowserWindow
const path = require('path')
const url = require('url')

// global reference to window
let mainWindow = null

function createWindow () {
// create the browser window
// create a new browser window
mainWindow = new BrowserWindow({"webPreferences":{"worldSafeExecuteJavaScript":true,"devTools":true,"nodeIntegration":false},"show":false,"icon":".\/assets\/logo.png"})
// remove menu
mainWindow.removeMenu()
// maximize menu
mainWindow.maximize()
// load index.html
mainWindow.loadURL(url.format({
pathname: path.join(__dirname, 'index.html'),
protocol: 'file:',
slashes: true
}))
// Wait for 'ready-to-show' to display our window
mainWindow.once('ready-to-show', function () {
// show the window
mainWindow.show()
})
// Emitted when the window is closed.
mainWindow.on('closed', function () {
// nullyfy window
let mainWindow = null
})
}

// Fired when electron is ready to create the window
app.on('ready', function () {
createWindow()
})
// Quit when all windows are closed.
app.on('window-all-closed', function () {
// On OS X it Is common for applications and their menu bar
// To stay active until the user quits explicitly with Cmd + Q
if (process.platform !== 'darwin') {
app.quit()
}
})
app.on('activate', function () {
// On OS X it's common to re-create a window in the app when the
// dock icon is clicked and there are no other windows open.
if (mainWindow === null) {
createWindow()
}
})
