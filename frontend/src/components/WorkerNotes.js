import classes from './Notes.module.css';

function WorkerNotes(props)
{

    return (
        <div className={classes.card}>
            <div className={classes.cardheader}>
                <h3 className={classes.h3}>Notes by {props.name}</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div>
                <ul className={classes.ul}>
                    {props.input.map(info => 
                        <li className={classes.item} key={info.note}>
                            <span className={classes.span}>{info.title}</span>
                            <span className={classes.span}>{info.date}</span>
                            <p className={classes.p}>{info.note}</p>
                        </li>
                    )}
                </ul>
            </div>
        </div>
    );
}

export default WorkerNotes;