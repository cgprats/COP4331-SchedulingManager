import classes from "./AccountInfo.module.css";
import NavBar from './NavBar';

import { useRef } from "react";
import { useState } from "react";

function AccountInfo() {

  var user = JSON.parse(localStorage.getItem('user_data'));

  const [flippedIsOpen, setFlippedIsOpen] = useState(false);

  const firstNameRef = useRef();
  const lastNameRef = useRef();
  const phoneRef = useRef();

  function getClassName()
  {
      if (flippedIsOpen) return classes.card_active;
      return classes.card;
  }

  function flip()
  {
      setFlippedIsOpen(true);
  }

  function flipBack(event)
  {
    event.preventDefault();
    setFlippedIsOpen(false);
  }


  return (
    <div className={classes.back}>
      <NavBar></NavBar>
      <div className={getClassName()}>
        <div className={classes.card_inner}>
          <div className={classes.card_front}>
            <h2 className={classes.h2}>Account Info</h2>
            <div>
              <table className={classes.table}>
                  <tr>
                      <th className={classes.first}></th>
                      <th className={classes.second}></th>
                  </tr>
                  <tr>
                    <td className={classes.first2}>First Name:</td>
                    <td className={classes.second2}>{user.FirstName}</td>
                  </tr>
                  <tr>
                    <td className={classes.first2}>Last Name:</td>
                    <td className={classes.second2}>{user.LastName}</td>
                  </tr>
                  <tr>
                    <td className={classes.first2}>Phone:</td>
                    <td className={classes.second2}>{user.Phone}</td>
                  </tr>
                  <tr>
                    <td className={classes.first2}>Email:</td>
                    <td className={classes.second2}>{user.Email}</td>
                  </tr>
                  <tr>
                    <td className={classes.first3}>Company Code:</td>
                    <td className={classes.second3}>{user.CompanyCode}</td>
                  </tr>
              </table>
            </div>
            <button className={classes.button} onClick={flip}>Edit</button>
          </div>
          <div className={classes.card_back}>
            <h2 className={classes.h2}>Account Info</h2>
            <div className={classes.spacer}></div>
            <form>
              <div>
                <label className={classes.label}>First Name:</label>
                <input
                  type="text"
                  className={classes.input}
                  defaultValue={user.FirstName}
                  required
                  id="firstName"
                  ref={firstNameRef}
                />
              </div>
              <div>
                <label className={classes.label}>Last Name:</label>
                <input
                  type="text"
                  className={classes.input}
                  defaultValue={user.LastName}
                  required
                  id="lastName"
                  ref={lastNameRef}
                />
              </div>
              <div>
                <label className={classes.label2}>Phone:</label>
                <input
                  type="text"
                  className={classes.input2}
                  defaultValue={user.Phone}
                  required
                  id="phone"
                  ref={phoneRef}
                />
              </div>
              <button className={classes.cancel} onClick={flipBack}>Cancel</button>
              <button className={classes.button}>Confirm</button>
            </form>
          </div>
           
          
        </div>
      </div>
    </div>
  );
}

export default AccountInfo;