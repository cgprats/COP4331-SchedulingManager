import {useState} from 'react';
import classes from './Notes.module.css';
import {useRef} from 'react';

function Notes(props)
{
    const [formVisible, setFormVisibility] = useState(false);
    const [msg, setMsg] = useState('');

    const noteRef = useRef();

    function loadNew()
    {
        setFormVisibility(true);
    }

    function closeNew(event)
    {
        event.preventDefault();
        setFormVisibility(false);
    }

    async function addHandler(event)
    {
        event.preventDefault();

        var dateobj = new Date();
        var datestr = dateobj.toISOString();
        var user = JSON.parse(localStorage.getItem('user_data'));

        var date = datestr.substring(0, 10);
        var note = noteRef.current.value;
        var fooid = props.jid;
        var title = props.title;

        const Data =
        {
            "fooid": fooid,
            "email": user.Email,
            "date": date,
            "note": note,
            "fn": user.FirstName,
            "ln": user.LastName,
            "title": title
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/addnote', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }

        if(res.error == 'Note added!')
        {
            var fn = props.onClick;
            fn();
        }
    }

    return (
        <div className={classes.card}>
            <div className={classes.cardheader}>
                <h3 className={classes.h3}>Job Notes</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div>
                <div className={classes.center}>
                    {msg && <p className={classes.error}>{msg}</p>}
                    {(!formVisible && !props.completed) && <button className={classes.button} onClick={loadNew}>Add Note</button>}
                </div>
                {formVisible && 
                    <div className={classes.center}>
                        <form>
                            <textarea rows='5' cols='75' className={classes.ta} placeholder='Note text' ref={noteRef}></textarea><br></br>
                            <button className={classes.cancel} onClick={closeNew}>Cancel</button>
                            <button className={classes.conf} onClick={addHandler}>Add Note</button>
                        </form>
                    </div>
                }
                <ul className={classes.ul}>
                    {props.notes.map(info => 
                        <li className={classes.item} key={info.note}>
                            <span className={classes.span}>{info.firstName} {info.lastName}</span>
                            <span className={classes.span}>{info.date}</span>
                            <p className={classes.p}>{info.note}</p>
                        </li>
                    )}
                </ul>
            </div>
        </div>
    );
}

export default Notes;