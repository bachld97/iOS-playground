import React from 'react';
import myProfilePic from '../avatar.jpg';
import '../App.css';


class PersistentHeader extends React.Component {
    render() {
      return (
        <div className='App-header'>
          <img src={myProfilePic} 
            className='Header-Avatar' 
            alt='Avatar' 
          />
          <h1> 
            Le Duy Bach
          </h1>
          <a href="https://medium.com/@ldbach97">Click to visit me on Medium!!</a>
        </div>
      );
    }
  }

  export default PersistentHeader;
