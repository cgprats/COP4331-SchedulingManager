import classes from './Timesheet.module.css';

function Timesheet(props)
{

    return (
        <div className={classes.card}>
            <div className={classes.cardheader}>
                <h3 className={classes.h3}>Timesheet</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div>
                <table className={classes.table}>
                    <tr>
                        <th className={classes.first}>Date</th>
                        <th className={classes.second}>Hours</th>
                        <th className={classes.third}>Team Member</th>
                    </tr>
                    {props.input.map(info => 
                        <tr>
                            <td className={classes.first2}>{info.date}</td>
                            <td className={classes.second2}>{info.start} - {info.end}</td>
                            <td className={classes.third2}>{info.name}</td>
                        </tr>
                    )}
                </table>
            </div>
        </div>
    );
}

export default Timesheet;