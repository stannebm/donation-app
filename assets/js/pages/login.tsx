import React from "react";
import axios from "axios";

class Login extends React.Component {

  constructor() {
    super();
    this.state = {
      username: '',
      password: ''
    };
  }

  handleUsername(event) {
    this.setState({ username: event.target.value })
  }

  handlePassword(event) {
    this.setState({ password: event.target.value })
  }

  handleSubmit (event) {
    event.preventDefault();
    axios({
      method: 'post',
      headers: { 
        "Content-Type": "application/json" 
      },
      url: 'http://localhost:4000/api/admins/login',
      data: {
        username: this.state.username,
        password: this.state.password
      }
    }).then( (response) => {
      console.log( response );
    });
  }

  render() {
    return (
      <section className="hero is-fullheight">
        <div className="hero-body">
          <div className="container has-text-centered">
            <div className="column is-4 is-offset-4">
              <h3 className="title has-text-black">Login</h3>
              <form onSubmit={this.handleSubmit.bind(this)}>

                <div className="field has-text-left">
                  <label className="label">Username</label>
                  <div className="control">
                    <input className="input" type="text"
                      value = {this.state.username}
                      onChange = {this.handleUsername.bind(this)}
                      required
                    />
                  </div>
                </div>

                <div className="field has-text-left">
                  <label className="label">Password</label>
                  <div className="control">
                    <input className="input" type="password"
                      value = {this.state.password}
                      onChange = {this.handlePassword.bind(this)}
                      required
                    />
                  </div>
                </div>

                <div className="field has-text-right">
                  <button type="submit" value="Submit" className="button is-primary">
                    SUBMIT
                  </button>
                </div>

              </form>
            </div>
          </div>
        </div>
      </section>
    )
  }
}
export default Login;