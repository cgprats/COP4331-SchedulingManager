import {useState} from 'react';
import classes from './Notes.module.css';

function Notes(props)
{
    const [formVisible, setFormVisibility] = useState(false);

    function loadNew()
    {
        setFormVisibility(true);
    }

    function closeNew()
    {
        setFormVisibility(false);
    }

    return (
        <div className={classes.card}>
            <div className={classes.cardheader}>
                <h3 className={classes.h3}>Job Notes</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div>
                <div className={classes.center}>
                    {!formVisible && <button className={classes.button} onClick={loadNew}>Add Note</button>}
                </div>
                {formVisible && 
                    <div className={classes.center}>
                        <form>
                            <textarea rows='5' cols='75' className={classes.ta} placeholder='Note text'></textarea><br></br>
                            <button className={classes.cancel} onClick={closeNew}>Cancel</button>
                            <button className={classes.conf}>Add Note</button>
                        </form>
                    </div>
                }
                <ul className={classes.ul}>
                    {props.input.map(info => 
                        <li className={classes.item} key={info.desc}>
                            <span className={classes.span}>{info.name}</span>
                            <span className={classes.span}>{info.date}</span>
                            <p className={classes.p}>{info.desc}</p>
                        </li>
                    )}
                </ul>
            </div>
        </div>
    );
}

export default Notes;