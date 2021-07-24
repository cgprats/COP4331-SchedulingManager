import Login2 from './Login2';
import LoginBackside from './LoginBackside';
import classes from './LoginFlip.module.css';
import {useState} from 'react';

function LoginFlip()
{
    const [flippedIsOpen, setFlippedIsOpen] = useState(false);

    function loadBackside()
    {
        setFlippedIsOpen(true);
    }

    function loadFrontside()
    {
        setFlippedIsOpen(false);
    }

    function getClassName()
    {
        if (flippedIsOpen) return classes.flip_card_active;
        return classes.flip_card;
    }

    return (
        <div className={classes.back}>
            <div className={getClassName()}>
                <div className={classes.flip_card_inner}>
                    <div className={classes.flip_card_front}>
                    <Login2 onClick={loadBackside}/>
                    </div>
                    <div className={classes.flip_card_back}>
                        <LoginBackside onClick={loadFrontside}/>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default LoginFlip;