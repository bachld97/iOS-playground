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
            BBlog - BachLD
          </h1>
        </div>
      );
    }
  }

  export default PersistentHeader;